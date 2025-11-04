//
//  CheckListView.swift
//  JeepChak
//
//  Created by 김은찬 on 10/4/25.
//

import SwiftUI

struct CheckListView: View {
    @StateObject private var viewModel = CheckListViewModel()

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
                    viewModel.showAddSheet = true
                }) {
                    Image("AddButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                }
                .padding(.trailing, 22)
                .padding(.bottom, 16)
            }
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $viewModel.showAddSheet) {
                AddCheckListView(
                    addCheckListItem: { newItem in
                        viewModel.addItem(title: newItem.title, date: newItem.date, image: newItem.image)
                    },
                    onDismiss: {
                        viewModel.showAddSheet = false
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
}

#Preview {
    CheckListView()
}

