//
//  PropertyCard.swift
//  JeepChak
//
//  Created by 김은찬 on 10/30/25.
//

import SwiftUI

struct PropertyCard: View {
    let property: Property

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topTrailing) {
                // 이미지
                Image(property.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 160)
                    .cornerRadius(6)
                    .clipped()
            }

            // 매물 정보
            VStack(alignment: .leading, spacing: 4) {
                Text(property.price)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.customBlack)
                Text("\(property.type) \(property.area)")
                    .font(.system(size: 11))
                    .foregroundColor(.customDarkGray)
                Text(property.address)
                    .font(.system(size: 11))
                    .foregroundColor(.customDarkGray)
                Text(property.detail)
                    .font(.system(size: 10))
                    .foregroundColor(.customGray300)
            }
        }
        .frame(width: 160)
        .background(.customWhite)
        .cornerRadius(6)
    }
}

