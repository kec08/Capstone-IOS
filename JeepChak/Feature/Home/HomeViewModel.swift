//
//  HomeViewModel.swift
//  Eodigo
//
//  Created by 김은찬 on 9/8/25.
//

import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var homepopularProperties: [Property] = []
    @Published var homerecentProperties: [RecentProperty] = []

    init() {
        // 모든 프로퍼티 초기화 이후 데이터 로드
        DispatchQueue.main.async {
            self.loadMockData()
        }
    }

    private func loadMockData() {
        // 인기 매물
        let mockPopularProperty = Property(
            address: "의성군 봉양면 화전리 129 파랑채",
            location: "봉양면",
            price: "월세 120",
            type: "원룸",
            area: "1층 15평",
            imageName: "Home_img1",
            detail: "깨끗하게 관리되어 있습니다."
        )
        self.homepopularProperties = Array(repeating: mockPopularProperty, count: 4)

        // 최근 많이 찾는 매물
        let mockRecentProperty = RecentProperty(
            type: "투룸",
            area: "2층 18평",
            imageName: "Home_img2",
            location: "의성군 봉양면 도리원리 58-2",
            price: "전세 4,500"
        )

        self.homerecentProperties = Array(repeating: mockRecentProperty, count: 4)
    }
}

