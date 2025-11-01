//
//  CheckListGridView.swift
//  JeepChak
//
//  Created by 김은찬 on 10/29/25.
//

import SwiftUI

struct CheckListGridView: View {
    @Binding var items: [CheckItem]
    @Binding var isEditing: Bool
    @Binding var itemToDelete: CheckItem?
    @Binding var showDeleteAlert: Bool
    var confirmDelete: (CheckItem) -> Void

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 20) {
            ForEach($items) { $item in
                VStack(alignment: .leading, spacing: 6) {
                    ZStack(alignment: .topTrailing) {
                        if let uiImage = item.image {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 158, height: 158)
                                .cornerRadius(8)
                            
                        } else if let imageName = item.imageName, !imageName.isEmpty { // 기본 데이터 이미지 검사 나중에 삭제
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 158, height: 158)
                                .cornerRadius(8)
                        } else {
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

                        if isEditing {
                            Button {
                                confirmDelete(item)
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
        .padding(.bottom, 20)
    }
}

