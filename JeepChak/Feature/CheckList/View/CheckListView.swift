//
//  CheckListView.swift
//  JeepChak
//

import SwiftUI

struct CheckListView: View {
    @StateObject private var viewModel = CheckListViewModel()
    @State private var showSavedView = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    // MARK: Header
                    CheckListHeaderView(
                        isEditing: $viewModel.isEditing,
                        hasItems: !viewModel.checkItems.isEmpty,
                        toggleEditing: viewModel.toggleEditing
                    )
                    .padding(.horizontal, 22)

                    Text("체크리스트")
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 22)
                        .padding(.bottom, 16)
                        .foregroundColor(Color.customBlack)

                    if viewModel.checkItems.isEmpty {
                        CheckListEmptyView()
                            .padding(.horizontal, 22)
                    } else {
                        ScrollView {
                            CheckListGridView(
                                items: $viewModel.checkItems,
                                isEditing: $viewModel.isEditing,
                                itemToDelete: $viewModel.itemToDelete,
                                showDeleteAlert: $viewModel.showDeleteAlert,
                                confirmDelete: viewModel.confirmDelete
                            )
                            .padding(.horizontal, 22)
                            .padding(.top, 8)
                        }
                    }

                    Spacer()
                }

                Button(action: {
                    showSavedView = true
                }) {
                    Image("AddButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                }
                .padding(.trailing, 22)
                .padding(.bottom, 27)
            }
            .background(Color.customWhite)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showSavedView) {
                AddChecklistFromWishlistView(
                    onPropertiesSelected: { properties in
                        for property in properties {
                            // 날짜 포맷팅 (T15:... 제거)
                            let formattedDate = formatDate(property.createdAt ?? "날짜 데이터가 없습니다")
                            viewModel.addItem(
                                title: property.name,
                                date: formattedDate,
                                image: property.image
                            )
                        }
                        showSavedView = false
                    }
                )
            }
            .alert("정말 삭제하시겠습니까?", isPresented: $viewModel.showDeleteAlert) {
                Button("취소", role: .cancel) { }
                Button("삭제", role: .destructive) {
                    if let itemToDelete = viewModel.itemToDelete {
                        viewModel.deleteItem(itemToDelete)
                    }
                }
            } message: {
                Text("체크리스트 항목을 삭제하면 복구할 수 없습니다.")
            }
        }
    }
    
    // 날짜 포맷팅 함수
    private func formatDate(_ dateString: String) -> String {
        // ISO 8601 형식 (2025-12-20T15:58:18.375109) 또는 일반 날짜 형식 처리
        if dateString.contains("T") {
            // ISO 8601 형식인 경우
            let components = dateString.components(separatedBy: "T")
            if let datePart = components.first {
                return datePart
            }
        }
        // 이미 날짜만 있는 경우 그대로 반환
        return dateString
    }
}

#Preview {
    CheckListView()
}
