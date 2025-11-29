//
//  StatisticsSection.swift
//  JeepChak
//
//  Created by 김은찬 on 11/5/25.
//

// StatisticsSection.swift

import SwiftUI

struct StatisticsSection: View {
    let userInfo: UserInfo

    var body: some View {
        HStack(spacing: 15) {
            NavigationLink {
                SavedView()
            } label: {
                StatCard(
                    icon: "My_wish",
                    title: "관심 매물",
                    imageWidth: 48,
                    imageHeight: 52
                )
            }

            NavigationLink {
                AnalyzeView()
            } label: {
                StatCard(
                    icon: "My_analyze",
                    title: "매물 분석",
                    imageWidth: 63,
                    imageHeight: 52
                )
            }

            NavigationLink {
                CheckListView()
            } label: {
                StatCard(
                    icon: "My_checkList",
                    title: "체크리스트",
                    imageWidth: 53,
                    imageHeight: 52
                )
            }
        }
    }
}
