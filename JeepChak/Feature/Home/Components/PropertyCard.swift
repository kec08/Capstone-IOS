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
                    .font(Font.system(size: 14, weight: .bold))
                    .foregroundColor(Color("customBlack"))
                Text("\(property.type) \(property.area)")
                    .font(Font.system(size: 11))
                    .foregroundColor(Color("customDarkGray"))
                Text(property.address)
                    .font(Font.system(size: 11))
                    .foregroundColor(Color("customDarkGray"))
                Text(property.detail)
                    .font(Font.system(size: 10))
                    .foregroundColor(Color("customGray300"))
            }
        }
        .frame(width: 160)
        .background(Color("customWhite"))
        .cornerRadius(6)
    }
}

