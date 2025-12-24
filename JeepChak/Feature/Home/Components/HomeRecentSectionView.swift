//
//  HomeRecentSectionView.swift
//  JeepChak
//
//  Created by 김은찬 on 10/30/25.
//

import SwiftUI

struct HomeRecentSectionView: View {
    let recentPropeties: [RecentProperty]
    @State private var navigateToMap: Bool = false
    @State private var selectedMapPropertyId: Int? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 6) {
                Image("Home_search")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .symbolRenderingMode(.multicolor)
                
                Text("최근 많이 찾는 봉양면 매물")
                    .font(Font.system(size: 18, weight: .bold))
                    .foregroundColor(Color("customBlack"))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(recentPropeties) { recentproperty in
                        RecentPropertyCard(property: recentproperty) { id in
                            selectedMapPropertyId = id
                            navigateToMap = true
                        }
                        .frame(width: 195)
                    }
                }
                .padding(.vertical, 4)
                .padding(.leading, 10)
            }
            
        }
        // "자세히 보기" 탭 시 MapView로 이동 후 해당 매물 시트 자동 표시
        .background(
            NavigationLink(
                destination: MapView(
                    showsCompactHeader: true,
                    showsBackButton: false,
                    initialSelectedPropertyId: selectedMapPropertyId
                ),
                isActive: $navigateToMap
            ) {
                EmptyView()
            }
            .hidden()
        )
    }
}

