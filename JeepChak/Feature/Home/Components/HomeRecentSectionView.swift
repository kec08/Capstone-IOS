//
//  HomeRecentSectionView.swift
//  JeepChak
//
//  Created by 김은찬 on 10/30/25.
//

import SwiftUI

struct HomeRecentSectionView: View {
    let recentPropeties: [RecentProperty]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 6) {
                Image("Home_search")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .symbolRenderingMode(.multicolor)
                
                Text("최근 많이 찾는 봉양면 매물")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.customBlack)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(recentPropeties) { recentproperty in
                        RecentPropertyCard(property: recentproperty)
                            .frame(width: 195)
                    }
                }
                .padding(.vertical, 4)
                .padding(.leading, 10)
            }
            
        }
    }
}

