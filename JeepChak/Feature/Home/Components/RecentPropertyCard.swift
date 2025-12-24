//
//  RecentPropertyCard.swift
//  JeepChak
//
//  Created by 김은찬 on 10/31/25.
//

import SwiftUI

struct RecentPropertyCard: View {
    let property: RecentProperty
    let onTapDetail: (Int) -> Void

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // MARK: - 이미지
            Image(property.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 195, height: 287)
                .clipped()
                .cornerRadius(14)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("customBlack").opacity(0.0),
                            Color("customBlack").opacity(0.3),
                            Color("customBlack").opacity(0.5)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .cornerRadius(14)
                )

            // MARK: - 텍스트 영역
            VStack(alignment: .leading, spacing: 6) {
                Text("\(property.type)   \(property.area)")
                    .font(Font.system(size: 10, weight: .medium))
                    .foregroundColor(Color("customWhite"))

                Text(property.location)
                    .font(Font.system(size: 12, weight: .semibold))
                    .foregroundColor(Color("customWhite"))
                    .lineLimit(1)

                Text(property.price)
                    .font(Font.system(size: 16, weight: .bold))
                    .foregroundColor(Color("customWhite"))
                    .padding(.top, 4)

                Button {
                    if let id = property.mapPropertyId {
                        onTapDetail(id)
                    }
                } label: {
                    Text("자세히 보기")
                        .font(Font.system(size: 10, weight: .bold))
                        .foregroundColor(Color("customWhite"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color("customWhite"), lineWidth: 1)
                        )
                }
                .disabled(property.mapPropertyId == nil)
                .opacity(property.mapPropertyId == nil ? 0.6 : 1.0)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(12)
        }
        .cornerRadius(8)
    }
}


struct RecentPropertyCard_Previews: PreviewProvider {
    static var previews: some View {
            RecentPropertyCard(
                property: RecentProperty(
                    type: "원룸",
                    area: "1층 15평",
                    imageName: "Home_img2",
                    location: "의성군 봉양면 화전리 129 파랑채",
                    price: "월세 120",
                    mapPropertyId: 11
                ),
                onTapDetail: { _ in }
            )
    }
}

