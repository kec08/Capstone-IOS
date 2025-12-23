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
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 20
        ) {
            ForEach(items) { item in
                if isEditing {
                    cardView(for: item)
                } else {
                    // 저장된 체크리스트는 FinalView로 바로 진입(하단 확인 버튼 없음)
                    NavigationLink(
                        destination: item.isSaved
                        ? AnyView(CheckListFinalView(checkItem: item, detailItems: item.detailItems, items: $items))
                        : AnyView(CheckListDetailView(checkItem: item, items: $items))
                    ) {
                        cardView(for: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.bottom, 20)
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
    
    @ViewBuilder
    func cardView(for item: CheckItem) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topTrailing) {
                Group {
                if let uiImage = item.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else if let imageName = item.imageName, !imageName.isEmpty {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("customGray_100"))
                        .overlay(
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 28))
                                    .foregroundColor(Color("customDarkGray"))
                                    .padding(.bottom, 6)
                                Text("사진을 추가해 보세요")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                        )
                }
                }
                .frame(width: 158, height: 158)
                .clipped()
                .cornerRadius(8)
                
                if isEditing {
                    Button {
                        confirmDelete(item)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(Color("customRed"))
                            .font(.system(size: 22))
                            .padding(6)
                    }
                }
            }

            Text(item.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color("customBlack"))

            Text(formatDate(item.date))
                .font(.system(size: 12))
                .foregroundColor(Color("customDarkGray"))
                .padding(.bottom, 16)
        }
    }
}
