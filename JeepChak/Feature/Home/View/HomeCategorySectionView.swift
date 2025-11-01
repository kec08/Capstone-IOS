//
//  HomeCategorySectionView.swift
//  JeepChak
//
//  Created by 김은찬 on 10/29/25.
//

import SwiftUI

struct HomeCategorySectionView: View {
    let categories: [(title: String, subtitle: String, detail: String, imageName: String, imageWidth: CGFloat, imageHeight: CGFloat)] = [
        ("원룸/투룸", "나에게 딱 맞는 원룸 찾기", "주변 모든 원룸을 더 쉽게 찾아보세요!", "Home_house", 41, 41),
        ("아파트", "나에게 딱 맞는 아파트 찾기", "나에 딱 맞는 아파트 매물을 찾아보세요!", "Home_apt", 53, 53),
        ("AI 맞춤 매물 추천", "나에게 딱 맞는 방 찾기", "AI 사용자 맞춤 매물을 추천해줍니다! 클릭하여 활용해보세요", "Home_map", 132, 62)
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 12) {
                categoryCard(categories[0])
                categoryCard(categories[1])
            }
            categoryCard(categories[2])
        }
    }

    @ViewBuilder
    private func categoryCard(_ item: (title: String, subtitle: String, detail: String, imageName: String, imageWidth: CGFloat, imageHeight: CGFloat)) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.customBlack)
                Text(item.subtitle)
                    .font(.system(size: 10))
                    .foregroundColor(.customDarkGray)
                Text(item.detail)
                    .font(.system(size: 9))
                    .foregroundColor(.customGray300)
            }
            Spacer()
            Image(item.imageName)
                .resizable()
                .frame(width: item.imageWidth, height: item.imageHeight)
        }
        .padding()
        .background(.customWhite)
        .cornerRadius(12)
    }
}
