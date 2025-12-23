//
//  SelectablePropertyCard.swift
//  JeepChak
//
//  Created by 김은찬 on 11/15/25.
//

import SwiftUI

struct SelectablePropertyCard: View {
    let property: SavedProperty
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                // 이미지
                    if let image = property.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                            .clipped()
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.customGray200)
                            )
                }
                
                // 정보
                VStack(alignment: .leading, spacing: 8) {
                    Text(property.type)
                        .font(.system(size: 12))
                        .foregroundColor(.customBlack)
                    
                    Text(property.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.customBlack)
                        .lineLimit(1)
                    
                    Text(property.details)
                        .font(.system(size: 13))
                        .foregroundColor(.customBlack)
                        .lineLimit(1)
                    
                    // 층수와 평수 정보 표시
                    if let floor = property.floor, let area = property.area {
                        Text("\(floor)층, \(area)평")
                            .font(.system(size: 12))
                            .foregroundColor(.customBlack)
                    } else if !property.description.isEmpty {
                    Text(property.description)
                        .font(.system(size: 12))
                        .foregroundColor(.customBlack)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        // 가격 정보 표시
                        if !property.price.isEmpty {
                        Text(property.price)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.customBlack)
                        } else if let deposit = property.deposit, let monthlyRent = property.monthlyRent {
                            Text("월세 \(SavedProperty.formatNumber(deposit))/\(SavedProperty.formatNumber(monthlyRent))")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.customBlack)
                        } else if let deposit = property.deposit, property.leaseType == "JEONSE" {
                            Text("전세 \(SavedProperty.formatNumber(deposit))")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.customBlack)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(
                color: isSelected
                    ? Color.customBlue.opacity(0.5)
                    : Color.clear,
                radius: 5
            )
            .shadow(color: Color.customBlack.opacity(0.05), radius: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
