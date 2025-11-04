//
//  StatisticsSection.swift
//  JeepChak
//
//  Created by 김은찬 on 11/5/25.
//

import SwiftUI

struct StatisticsSection: View {
    let userInfo: UserInfo

    var body: some View {
        HStack(spacing: 15) {
            StatCard(
                icon: "My_wish",
                title: "관심 매물",
                count: userInfo.wishCount,
                imageWidth: 38,
                imageHeight: 47
            )
            StatCard(
                icon: "My_analyze",
                title: "매물 분석",
                count: userInfo.analysisCount,
                imageWidth: 55,
                imageHeight: 47
            )
            StatCard(
                icon: "My_checkList",
                title: "체크리스트",
                count: userInfo.checklistCount,
                imageWidth: 48,
                imageHeight: 47
            )
        }
    }
}
