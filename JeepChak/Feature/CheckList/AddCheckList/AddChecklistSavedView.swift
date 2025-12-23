//
//  AddChecklistSavedView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/15/25.
//

import SwiftUI
import Combine

struct AddChecklistFromWishlistView: View {
    @StateObject private var viewModel = SavedViewModel()
    private let checklistService = ChecklistService()
    @State private var selectedProperties: Set<Int> = []
    @State private var showAILoading = false
    @State private var showAIResult = false
    @State private var generatedChecklistItems: [GeneratedChecklistResponse] = []
    @State private var selectedPropertyForAI: SavedProperty?
    @State private var aiGeneratedDetailItems: [DetailItem] = [] // AI 생성 체크리스트 항목들
    @State private var aiCheckItems: [AICheckItem] = [] // 변환된 체크리스트 항목들
    @State private var cancellables = Set<AnyCancellable>()
    @Environment(\.dismiss) var dismiss
    var onPropertiesSelected: (([SavedProperty], [DetailItem]) -> Void)? // DetailItems도 함께 전달
    
    var body: some View {
        VStack(spacing: 0) {
            // 타이틀
            Text("체크리스트 추가하기")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.customBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 20)
            
            // 매물 목록
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.properties) { property in
                        SelectablePropertyCard(
                            property: property,
                            isSelected: selectedProperties.contains(property.id),
                            onSelect: {
                                if selectedProperties.contains(property.id) {
                                    selectedProperties.remove(property.id)
                                } else {
                                    selectedProperties.removeAll()
                                    selectedProperties.insert(property.id)
                                }
                            }
                        )
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 20)
                .padding(.bottom, 100)
            }
            
            Spacer()
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .overlay(
            VStack {
                Spacer()
                Button(action: {
                    let selected = viewModel.properties.filter { selectedProperties.contains($0.id) }
                    if let property = selected.first {
                        // AI 체크리스트 생성 요청
                        selectedPropertyForAI = property
                        requestAIChecklist(propertyId: property.propertyId)
                    }
                }) {
                    Text("추가하기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedProperties.isEmpty ? Color.gray.opacity(0.3) : Color.cyan)
                        .cornerRadius(12)
                }
                .disabled(selectedProperties.isEmpty)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
                .background(Color.white)
            }
        )
        .sheet(isPresented: $showAILoading) {
            AILoadingView {
            }
        }
        .sheet(isPresented: $showAIResult) {
            if !aiCheckItems.isEmpty {
                AIGeneratedListView(
                    checklistItems: aiCheckItems,
                    onConfirm: { selectedItems in
                        showAIResult = false
                        // 체크리스트에 추가 - AI 생성 항목들도 함께 전달
                        if let property = selectedPropertyForAI {
                            // 선택된 항목들을 DetailItem으로 변환
                            let detailItems = selectedItems.map { DetailItem(name: $0.name) }
                            onPropertiesSelected?([property], detailItems)
                        }
                        dismiss()
                    }
                )
            } else {
                // 빈 뷰 (이 경우는 발생하지 않아야 함)
                VStack {
                    Text("체크리스트 항목이 없습니다")
                        .padding()
                }
            }
        }
    }
    
    private func requestAIChecklist(propertyId: Int) {
        let request = ChecklistGenerateRequest(propertyId: propertyId)
        showAILoading = true
        generatedChecklistItems = [] // 초기화
        
        checklistService.generateChecklist(request: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                showAILoading = false
                if case .failure(let error) = completion {
                    print("체크리스트 생성 실패: \(error.localizedDescription)")
                    // 오류 발생 시에도 결과 화면을 표시하여 사용자가 직접 추가할 수 있도록 함
                    generatedChecklistItems = []
                    showAIResult = true
                }
            } receiveValue: { items in
                // API 응답 처리 - contents 배열의 각 항목을 처리
                print("생성된 체크리스트 응답 수: \(items.count)")
                
                // 모든 contents를 수집하여 하나의 배열로 합침
                var allContents: [String] = []
                for item in items {
                    if let contents = item.contents {
                        allContents.append(contentsOf: contents)
                    }
                }
                
                print("전체 체크리스트 항목 수 (필터링 전): \(allContents.count)")
                
                // JSON 마커 및 불필요한 문자 필터링
                let filteredContents = allContents.compactMap { content -> String? in
                    var trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // JSON 마커만 제거 (실제 체크리스트 항목은 보존)
                    if trimmed == "```json" || trimmed == "```" || trimmed == "{" || trimmed == "}" ||
                       trimmed == "\"contents\": [" || trimmed == "]" || 
                       (trimmed.hasPrefix("\"contents\":") && !trimmed.contains("확인") && !trimmed.contains("점검") && !trimmed.contains("평가")) {
                        return nil
                    }
                    
                    // 빈 문자열 제거
                    if trimmed.isEmpty {
                        return nil
                    }
                    
                    // 앞뒤 따옴표 제거 (하지만 내용이 있는 경우만)
                    if trimmed.hasPrefix("\"") && trimmed.count > 1 {
                        trimmed = String(trimmed.dropFirst())
                    }
                    if trimmed.hasSuffix("\"") && trimmed.count > 1 {
                        trimmed = String(trimmed.dropLast())
                    }
                    
                    // 끝의 쉼표와 따옴표 제거
                    if trimmed.hasSuffix("\",") {
                        trimmed = String(trimmed.dropLast(2))
                    }
                    
                    // 이스케이프된 따옴표 처리
                    trimmed = trimmed.replacingOccurrences(of: "\\\"", with: "\"")
                    
                    // 최종 공백 제거
                    trimmed = trimmed.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // 최소 길이 체크 (너무 짧은 항목은 제외)
                    if trimmed.count < 3 {
                        return nil
                    }
                    
                    return trimmed.isEmpty ? nil : trimmed
                }
                
                print("필터링된 체크리스트 항목 수: \(filteredContents.count)")
                
                // 수집된 모든 항목을 AICheckItem으로 변환
                DispatchQueue.main.async {
                    var convertedItems: [AICheckItem] = []
                    if !filteredContents.isEmpty {
                        // 필터링된 contents를 AICheckItem으로 변환
                        for content in filteredContents {
                            convertedItems.append(AICheckItem(name: content))
            }
                        // 필터링된 contents를 하나의 GeneratedChecklistResponse로 저장
                        self.generatedChecklistItems = [GeneratedChecklistResponse(contents: filteredContents)]
                        print("generatedChecklistItems 설정 완료: \(self.generatedChecklistItems.count)개, contents: \(filteredContents.count)개")
                        
                        // 변환된 항목들을 저장
                        self.aiCheckItems = convertedItems
                        print("aiCheckItems 설정 완료: \(self.aiCheckItems.count)개")
                        
                        self.showAILoading = false
                        self.showAIResult = true
                    } else {
                        print("경고: 체크리스트 항목이 없습니다. 체크리스트를 생성하지 않습니다.")
                        self.generatedChecklistItems = []
                        self.aiCheckItems = []
                        self.showAILoading = false
                        // 값이 없으면 결과 화면을 표시하지 않고 바로 닫기
                        self.dismiss()
                    }
                }
            }
            .store(in: &cancellables)
    }
}


struct AddChecklistSavedView_Previews: PreviewProvider {
    static var previews: some View {
            AddChecklistFromWishlistView()
    }
}
