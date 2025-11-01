//
//  HomePopularSectionView.swift
//  JeepChak
//
//  Created by 김은찬 on 10/29/25.
//

import SwiftUI

struct HomePopularSectionView: View {
    let properties: [Property]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 6) {
                Image("Home_fire")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .symbolRenderingMode(.multicolor)
                Text("지금 가장 인기있는 봉양면 매물")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.customBlack)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(properties) { property in
                        PropertyCard(property: property)
                            .frame(width: 168)
                    }
                }
                .padding(.vertical, 4)
                .padding(.leading, 2)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(properties) { property in
                        PropertyCard(property: property)
                            .frame(width: 168)
                    }
                }
                .padding(.vertical, 4)
                .padding(.leading, 2)
            }
            
        }
    }
}
