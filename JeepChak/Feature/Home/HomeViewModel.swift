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
        // 인기 매물 (10개, 이미지: property_1 ~ property_10)
        self.homepopularProperties = [
            Property(
                address: "의성군 봉양면 화전리 129 파랑채",
                location: "봉양면",
                price: "월세 120",
                type: "원룸",
                area: "1층 15평",
                imageName: "property_1",
                detail: "채광 좋고 관리 잘 된 매물"
            ),
            Property(
                address: "의성군 의성읍 중앙로 123",
                location: "의성읍",
                price: "월세 80/10",
                type: "원룸",
                area: "2층 12평",
                imageName: "property_2",
                detail: "역세권, 편의시설 접근 좋아요"
            ),
            Property(
                address: "의성군 봉양면 도리원리 58-2",
                location: "봉양면",
                price: "전세 4,500",
                type: "투룸",
                area: "2층 18평",
                imageName: "property_3",
                detail: "조용한 주거환경, 주차 가능"
            ),
            Property(
                address: "의성군 의성읍 시장로 234",
                location: "의성읍",
                price: "월세 1000/60",
                type: "오피스텔",
                area: "5층 22평",
                imageName: "property_4",
                detail: "생활권 최상, 실내 컨디션 우수"
            ),
            Property(
                address: "의성군 의성읍 군청로 567",
                location: "의성읍",
                price: "전세 5,000",
                type: "아파트",
                area: "4층 30평",
                imageName: "property_5",
                detail: "학군/편의시설 좋고 관리비 합리적"
            ),
            Property(
                address: "의성군 봉양면 신평리 22",
                location: "봉양면",
                price: "월세 70/5",
                type: "빌라",
                area: "1층 20평",
                imageName: "property_6",
                detail: "리모델링 되어 깔끔한 내부"
            ),
            Property(
                address: "의성군 의성읍 초등로 89",
                location: "의성읍",
                price: "월세 90/15",
                type: "원룸",
                area: "3층 14평",
                imageName: "property_7",
                detail: "보안 좋고 조용한 라인"
            ),
            Property(
                address: "의성군 의성읍 터미널로 678",
                location: "의성읍",
                price: "월세 500/35",
                type: "오피스텔",
                area: "6층 24평",
                imageName: "property_8",
                detail: "교통 편리, 풀옵션"
            ),
            Property(
                address: "의성군 봉양면 화전리 77",
                location: "봉양면",
                price: "전세 3,800",
                type: "빌라",
                area: "2층 25평",
                imageName: "property_9",
                detail: "채광/통풍 좋고 상태 양호"
            ),
            Property(
                address: "의성군 의성읍 공원로 567",
                location: "의성읍",
                price: "월세 1200/65",
                type: "아파트",
                area: "5층 32평",
                imageName: "property_10",
                detail: "공원 인근, 생활 편의시설 가까움"
            )
        ]

        // 최근 많이 찾는 매물 (4개, 이미지: property_11 ~ property_14)
        self.homerecentProperties = [
            RecentProperty(
                type: "원룸",
                area: "1층 13평",
                imageName: "property_11",
                location: "의성군 봉양면 화전리 101",
                price: "월세 60/5",
                mapPropertyId: 11
            ),
            RecentProperty(
                type: "투룸",
                area: "2층 18평",
                imageName: "property_12",
                location: "의성군 봉양면 도리원리 58-2",
                price: "전세 4,500",
                mapPropertyId: 12
            ),
            RecentProperty(
                type: "오피스텔",
                area: "5층 22평",
                imageName: "property_13",
                location: "의성군 의성읍 시장로 234",
                price: "월세 1000/60",
                mapPropertyId: 13
            ),
            RecentProperty(
                type: "아파트",
                area: "4층 30평",
                imageName: "property_14",
                location: "의성군 의성읍 군청로 567",
                price: "전세 5,000",
                mapPropertyId: 14
            )
        ]
    }
}

    