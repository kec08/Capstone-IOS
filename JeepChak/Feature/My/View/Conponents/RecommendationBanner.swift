//
//  RecommendationBanner.swift
//  JeepChak
//
//  Created by 김은찬 on 11/5/25.
//

import SwiftUI

struct RecommendationBanner: View {
    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text("나에게 딱 맞는 방 찾기")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)

                Text("지도를 통해 내 주변 나에게\n딱 맞는 방을찾아보세요!")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineSpacing(4)
            }

            Spacer()

            Image("My_map")
                .resizable()
                .scaledToFit()
                .frame(width: 134, height: 125)
        }
        .padding(20)
        .background(Color.customWhite)
        .cornerRadius(12)
    }
}
