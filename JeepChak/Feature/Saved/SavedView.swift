//
//  SavedView.swift
//  JeepChak
//

import SwiftUI

struct SavedView: View {
    @StateObject private var viewModel = SavedViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var showAddView = false
    @State private var showAILoading = false
    @State private var showAIResult = false
    @State private var selectedProperty: SavedProperty?
    
    var onPropertySelected: ((SavedProperty) -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            SavedHeaderView(
                onBackTapped: { dismiss() },
                onAddTapped: { showAddView = true }
            )
            
            // 내용
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.errorMessage {
                errorView(message: error)
            } else if viewModel.properties.isEmpty {
                emptyStateView
            } else {
                propertyListView
            }
        }
        .background(.customWhite)
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddView) {
            AddCheckListView(
                addCheckListItem: { newItem in
                    viewModel.createProperty(from: newItem) { saved in
                        selectedProperty = saved
                        showAddView = false
                        showAILoading = true
                    }
                },
                onDismiss: { showAddView = false }
            )
        }
        .sheet(isPresented: $showAILoading) {
            AILoadingView {
                showAILoading = false
                showAIResult = true
            }
        }
        .sheet(isPresented: $showAIResult) {
            AIGeneratedListView(onConfirm: {
                showAIResult = false
                
                // 체크리스트에 추가
                if let property = selectedProperty {
                    onPropertySelected?(property)
                    dismiss()
                }
            })
        }
    }
    
    // 매물 리스트 뷰
    private var propertyListView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.properties) { property in
                    SavedPropertyCard(property: property)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            selectedProperty = property
                            showAILoading = true
                        }
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    // 로딩 뷰
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Text("매물 목록을 불러오는 중...")
                .font(.system(size: 14))
                .foregroundColor(.customDarkGray)
                .padding(.top, 16)
            Spacer()
        }
    }
    
    // 에러 뷰
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red.opacity(0.6))
            
            Text("매물을 불러올 수 없습니다")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                viewModel.fetchProperties()
            }) {
                Text("다시 시도")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Color.cyan)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
            
            Spacer()
        }
    }
    
    // 빈 상태 뷰
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("관심 매물이 없습니다.")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Text("직접 추가 버튼을 눌러 매물을 추가해보세요!")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Button(action: {
                showAddView = true
            }) {
                Text("직접 추가")
                    .font(.system(size: 16))
                    .foregroundColor(.cyan)
                Image(systemName: "plus")
                    .font(.system(size: 14))
                    .foregroundColor(.cyan)
            }
            .padding(.top, 14)
            
            Spacer()
        }
    }
}
extension SavedView {
    init(mockProperties: [SavedProperty]) {
        self._viewModel = StateObject(
            wrappedValue: SavedViewModel(mockProperties: mockProperties)
        )
    }
}



#Preview("빈 상태") {
    NavigationView {
        SavedView()
    }
}

#Preview("데이터 있음") {
    NavigationView {
        SavedView(
            mockProperties: [
                SavedProperty(
                    id: 1,
                    propertyId: 1,
                    image: UIImage(contentsOfFile: "CheckListHouse1"),
                    type: "원룸",
                    name: "성수동 풀옵션 원룸",
                    details: "서울특별시 성동구 성수동1가",
                    description: "채광 좋고, 주변 조용함",
                    price: "월세 80/10",
                    createdAt: "2025-11-15"
                ),
                SavedProperty(
                    id: 2,
                    propertyId: 2,
                    image: UIImage(contentsOfFile: "CheckListHouse1"),
                    type: "투룸",
                    name: "역삼역 도보 3분 투룸",
                    details: "서울특별시 강남구 역삼동",
                    description: "회사와 가까움",
                    price: "전세 4.5억",
                    createdAt: "2025-11-10"
                )
            ]
        )
    }
}

