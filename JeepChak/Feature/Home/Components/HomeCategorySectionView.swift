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
        ("대출 가이드", "나에게 딱 맞춤 대출 가이드", "짧은 설문만으로 최적의 대출 정보를 찾아보세요!", "Home_map", 132, 62)
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 12) {
                categoryCard(categories[0], isLoanGuide: false)
                categoryCard(categories[1], isLoanGuide: false)
            }
            categoryCard(categories[2], isLoanGuide: true)
        }
    }

    @ViewBuilder
    private func categoryCard(_ item: (title: String, subtitle: String, detail: String, imageName: String, imageWidth: CGFloat, imageHeight: CGFloat), isLoanGuide: Bool) -> some View {
        if isLoanGuide {
            NavigationLink {
                LoanGuideIntroView(source: .home)
            } label: {
                cardContent(item)
            }
        } else {
            cardContent(item)
        }
    }

    @ViewBuilder
    private func cardContent(_ item: (title: String, subtitle: String, detail: String, imageName: String, imageWidth: CGFloat, imageHeight: CGFloat)) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color("customBlack"))
                Text(item.subtitle)
                    .font(.system(size: 10))
                    .foregroundColor(Color("customDarkGray"))
                Text(item.detail)
                    .font(.system(size: 9))
                    .foregroundColor(Color("customGray_300"))
            }
            Spacer()
            Image(item.imageName)
                .resizable()
                .frame(width: item.imageWidth, height: item.imageHeight)
        }
        .padding()
        .background(Color("customWhite"))
        .cornerRadius(12)
    }
}
