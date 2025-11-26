//
//  SavedPropertyCard.swift
//  JeepChak
//
//  Created by 김은찬 on 11/15/25.
//

import SwiftUI

struct SavedPropertyCard: View {
    let property: SavedProperty
    
    var body: some View {
        HStack(spacing: 16) {
            // 이미지
            if let image = property.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                    .clipped()
                    .padding(.top, -5)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 146, height: 138)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.customDarkGray)
                    )
            }
            
            // 정보
            VStack(alignment: .leading, spacing: 8) {
                Text(property.type)
                    .font(.system(size: 12))
                    .foregroundColor(.customDarkGray)
                
                Text(property.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.customBlack)
                    .lineLimit(1)
                
                Text(property.details)
                    .font(.system(size: 13))
                    .foregroundColor(.customDarkGray)
                    .lineLimit(1)
                
                Text(property.description)
                    .font(.system(size: 12))
                    .foregroundColor(.customDarkGray)
                    .lineLimit(2)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text(property.price)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.customBlack)
                        .padding(.horizontal, 10)
                }
            }
            .padding(.vertical, 4)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    SavedPropertyCard(
        property: SavedProperty(
            id: 1,
            propertyId: 1,
            image: UIImage(contentsOfFile: "CheckListHouse1"),
            type: "원룸",
            name: "성수동 풀옵션 원룸",
            details: "서울특별시 성동구 성수동1가 123-4",
            description: "채광 좋고 주변이 조용함",
            price: "월세 80 / 10",
            createdAt: "2025-11-15"
        )
    )
}
