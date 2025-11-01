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
                    headerView
                        .padding(.horizontal, 22)

                    Text("체크리스트")
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 22)
                        .padding(.bottom, 16)
                    
                    if viewModel.checkItems.isEmpty {
                        emptyStateView
                            .padding(.horizontal, 22)
                    } else {
                        ScrollView {
                            checkListGrid
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

// MARK: - Subviews
private extension CheckListView {
    // MARK: - Header
    var headerView: some View {
        HStack {
            Button(action: {
                // TODO: 뒤로가기 액션
            }) {
                Image("Header_BackIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 13, height: 25)
            }

            Spacer()
                .frame(width: 133)

            Image("Header_AppIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 27)

            Spacer()

            if !viewModel.checkItems.isEmpty {
                Button(action: {
                    viewModel.toggleEditing()
                }) {
                    Text(viewModel.isEditing ? "완료" : "삭제")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.customBlack)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.bottom, 30)
        .background(Color.white)
    }

    // MARK: - Empty State
    var emptyStateView: some View {
        VStack(spacing: 12) {
            Text("체크리스트가 없습니다")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color.customBlack)
            
            Text("+ 버튼을 눌러\n체크리스트를 추가해보세요!")
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .foregroundColor(.customDarkGray)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Grid View
    var checkListGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 20
        ) {
            ForEach(viewModel.checkItems) { item in
                if viewModel.isEditing {
                    // 편집 모드: 네비게이션 없이
                    cardView(for: item)
                } else {
                    // 일반 모드: NavigationLink로 감싸기
                    NavigationLink(destination: CheckListDetailView(title: item.title)) {
                        cardView(for: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    func cardView(for item: CheckItem) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topTrailing) {
                if let uiImage = item.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 158, height: 158)
                        .clipped()
                        .cornerRadius(8)
                }
                else if let imageName = item.imageName, !imageName.isEmpty {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 158, height: 158)
                        .clipped()
                        .cornerRadius(8)
                }
                else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.customGray100)
                        .frame(width: 160, height: 158)
                        .overlay(
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 28))
                                    .foregroundColor(Color.customDarkGray)
                                    .padding(.bottom, 6)
                                Text("사진을 추가해 보세요")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                        )
                }
                
                if viewModel.isEditing {
                    Button {
                        viewModel.confirmDelete(item)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(Color.customRed)
                            .font(.system(size: 22))
                            .padding(6)
                    }
                }
            }

            Text(item.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.customBlack)

            Text(item.date)
                .font(.system(size: 12))
                .foregroundColor(.customDarkGray)
                .padding(.bottom, 16)
        }
    }
}

#Preview {
    CheckListView()
}
