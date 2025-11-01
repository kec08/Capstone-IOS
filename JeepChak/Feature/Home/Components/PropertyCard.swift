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

                // 좋아요 버튼
                Button(action: {}) {
                    Image("Home_heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 14)
                }
                .padding(10)
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


#Preview {
    PropertyCard(
        property: Property(
            address: "의성군 봉양면 화전리 129 파랑채",
            location: "봉양면",
            price: "월세 120",
            type: "원룸",
            area: "1층 15평",
            imageName: "Home_img1",
            detail: "깨끗하게 관리되어 있습니다."
        )
    )
}
