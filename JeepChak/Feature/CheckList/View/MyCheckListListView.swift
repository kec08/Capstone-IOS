//
//  MyCheckListListView.swift
//  JeepChak
//
//  Created by 김은찬 on 12/24/25.
//

import SwiftUI

struct MyCheckListListView: View {
    @StateObject private var viewModel = CheckListViewModel()
    @Environment(\.dismiss) private var dismiss

    @State private var showAddSheet: Bool = false

    var body: some View {
        ZStack {
            Color("customWhite")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if viewModel.checkItems.isEmpty {
                    CheckListEmptyView()
                        .padding(.horizontal, 22)
                        .padding(.top, 12)
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
                        .padding(.top, 12)
                    }
                }

                Spacer(minLength: 0)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.loadChecklistsIfNeeded()
        }
        .sheet(isPresented: $showAddSheet) {
            AddChecklistFromWishlistView(
                onPropertiesSelected: { properties, detailItems in
                    for property in properties {
                        let formattedDate = formatDate(property.createdAt ?? "날짜 데이터가 없습니다")

                        let newItem = CheckItem(
                            title: property.name,
                            date: formattedDate,
                            imageName: nil,
                            image: property.image,
                            detailItems: detailItems,
                            propertyId: property.propertyId
                        )

                        withAnimation {
                            viewModel.checkItems.append(newItem)
                        }
                    }
                    showAddSheet = false
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
        .alert("불러오기 실패", isPresented: $viewModel.showLoadErrorAlert) {
            Button("확인", role: .cancel) {
                viewModel.errorMessage = nil
            }
            Button("다시 시도") {
                viewModel.errorMessage = nil
                viewModel.refresh()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color("customBlack"))
                    .frame(width: 44, height: 44, alignment: .center)
            }

            Spacer()

            Text("체크리스트")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color("customBlack"))

            Spacer()

            Button {
                showAddSheet = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color("customBlack"))
                    .frame(width: 44, height: 44, alignment: .center)
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 6)
        .padding(.bottom, 10)
        .background(Color("customWhite"))
    }

    // 날짜 포맷팅 함수
    private func formatDate(_ dateString: String) -> String {
        if dateString.contains("T") {
            let components = dateString.components(separatedBy: "T")
            if let datePart = components.first { return datePart }
        }
        return dateString
    }
}
