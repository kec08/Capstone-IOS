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
    @State private var cancellables = Set<AnyCancellable>()
    @Environment(\.dismiss) var dismiss
    var onPropertiesSelected: (([SavedProperty]) -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            // 타이틀
            Text("체크리스트 추가하기")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
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
            AIGeneratedListView(
                checklistItems: generatedChecklistItems.map { AICheckItem(name: $0.content) },
                onConfirm: {
                    showAIResult = false
                    // 체크리스트에 추가
                    if let property = selectedPropertyForAI {
                        onPropertiesSelected?([property])
                    }
                    dismiss()
                }
            )
        }
    }
    
    private func requestAIChecklist(propertyId: Int) {
        let request = ChecklistGenerateRequest(propertyId: propertyId)
        showAILoading = true
        
        checklistService.generateChecklist(request: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("체크리스트 생성 실패: \(error.localizedDescription)")
                    showAILoading = false
                    generatedChecklistItems = []
                    showAIResult = true
                }
            } receiveValue: { items in
                generatedChecklistItems = items
                // 로딩 완료 후 결과 화면 표시
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showAILoading = false
                    showAIResult = true
                }
            }
            .store(in: &cancellables)
    }
}

#Preview {
    AddChecklistFromWishlistView()
}
