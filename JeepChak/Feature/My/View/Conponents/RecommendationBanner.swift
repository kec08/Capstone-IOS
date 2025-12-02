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
                Text("대출 가이드")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)

                Text("짧은 설문만으로 최적의\n대출 정보를 찾아보세요!")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineSpacing(4)
            }

            Spacer()

            Image("Home_map")
                .resizable()
                .scaledToFit()
                .frame(width: 134, height: 125)
        }
        .padding(20)
        .background(Color.customWhite)
        .cornerRadius(12)
    }
}
