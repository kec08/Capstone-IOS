//
//  MapViewModel.swift
//  JeepChak
//
//  Created by 김은찬 on 12/22/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class MapViewModel: ObservableObject {
    @Published var selectedProperty: MapProperty? = nil
    @Published var isDetailPresented: Bool = false
    
    // 의성군 중심 좌표
    @Published var centerLat: Double = 36.3529
    @Published var centerLng: Double = 128.6970
    
    // 의성군 매물 데이터 50개 - 의성군 주변으로 완전 랜덤 배치
    // 의성군 좌표 범위: 위도 36.25~36.45, 경도 128.55~128.85
    @Published var properties: [MapProperty] = [
        MapProperty(id: 1, name: "의성역 근처 원룸", address: "경상북도 의성군 의성읍 중앙로 123", propertyType: "ONE_ROOM", floor: 2, builtYear: 2018, area: 18, marketPrice: 15000, leaseType: "MONTHLY_RENT", deposit: 500, monthlyRent: 35, memo: "의성역 도보 5분 거리, 역세권 원룸", lat: 36.3287, lng: 128.7123),
        MapProperty(id: 2, name: "의성읍 중심가 빌라", address: "경상북도 의성군 의성읍 의성로 456", propertyType: "VILLA", floor: 3, builtYear: 2015, area: 25, marketPrice: 25000, leaseType: "MONTHLY_RENT", deposit: 1000, monthlyRent: 50, memo: "의성읍 중심가 위치, 주차 가능", lat: 36.3645, lng: 128.6789),
        MapProperty(id: 3, name: "의성고등학교 앞 원룸", address: "경상북도 의성군 의성읍 학교길 78", propertyType: "ONE_ROOM", floor: 1, builtYear: 2020, area: 20, marketPrice: 18000, leaseType: "JEONSE", deposit: 3000, monthlyRent: nil, memo: "의성고등학교 도보 3분, 신축 원룸", lat: 36.2912, lng: 128.7456),
        MapProperty(id: 4, name: "의성시장 근처 오피스텔", address: "경상북도 의성군 의성읍 시장로 234", propertyType: "OFFICETEL", floor: 5, builtYear: 2019, area: 22, marketPrice: 20000, leaseType: "MONTHLY_RENT", deposit: 800, monthlyRent: 45, memo: "의성시장 인근, 생활 편의시설 접근 용이", lat: 36.3756, lng: 128.6234),
        MapProperty(id: 5, name: "의성군청 앞 아파트", address: "경상북도 의성군 의성읍 군청로 567", propertyType: "APARTMENT", floor: 4, builtYear: 2012, area: 30, marketPrice: 30000, leaseType: "JEONSE", deposit: 5000, monthlyRent: nil, memo: "의성군청 도보 5분, 조용한 주거 환경", lat: 36.3423, lng: 128.7891),
        MapProperty(id: 6, name: "의성중앙초등학교 근처 빌라", address: "경상북도 의성군 의성읍 초등로 89", propertyType: "VILLA", floor: 2, builtYear: 2017, area: 28, marketPrice: 28000, leaseType: "MONTHLY_RENT", deposit: 1200, monthlyRent: 55, memo: "초등학교 인근, 가족 단위 거주 적합", lat: 36.4012, lng: 128.6543),
        MapProperty(id: 7, name: "의성보건소 옆 원룸", address: "경상북도 의성군 의성읍 보건로 345", propertyType: "ONE_ROOM", floor: 3, builtYear: 2016, area: 19, marketPrice: 16000, leaseType: "MONTHLY_RENT", deposit: 600, monthlyRent: 40, memo: "의성보건소 인근, 의료시설 접근 용이", lat: 36.2678, lng: 128.7012),
        MapProperty(id: 8, name: "의성공용버스터미널 앞 오피스텔", address: "경상북도 의성군 의성읍 터미널로 678", propertyType: "OFFICETEL", floor: 6, builtYear: 2021, area: 24, marketPrice: 22000, leaseType: "MONTHLY_RENT", deposit: 900, monthlyRent: 50, memo: "버스터미널 도보 2분, 교통 편리", lat: 36.3891, lng: 128.7123),
        MapProperty(id: 9, name: "의성읍사무소 근처 빌라", address: "경상북도 의성군 의성읍 읍사무소길 12", propertyType: "VILLA", floor: 1, builtYear: 2014, area: 26, marketPrice: 26000, leaseType: "JEONSE", deposit: 4000, monthlyRent: nil, memo: "읍사무소 인근, 행정기관 접근 용이", lat: 36.3123, lng: 128.5678),
        MapProperty(id: 10, name: "의성도서관 옆 원룸", address: "경상북도 의성군 의성읍 도서관길 234", propertyType: "ONE_ROOM", floor: 2, builtYear: 2019, area: 21, marketPrice: 17000, leaseType: "MONTHLY_RENT", deposit: 700, monthlyRent: 42, memo: "도서관 도보 3분, 조용한 학습 환경", lat: 36.3567, lng: 128.8234),
        MapProperty(id: 11, name: "의성체육공원 근처 아파트", address: "경상북도 의성군 의성읍 체육로 567", propertyType: "APARTMENT", floor: 5, builtYear: 2011, area: 32, marketPrice: 32000, leaseType: "MONTHLY_RENT", deposit: 1500, monthlyRent: 60, memo: "체육공원 인근, 운동하기 좋은 환경", lat: 36.2789, lng: 128.6456),
        MapProperty(id: 12, name: "의성농협 앞 빌라", address: "경상북도 의성군 의성읍 농협로 890", propertyType: "VILLA", floor: 3, builtYear: 2018, area: 27, marketPrice: 27000, leaseType: "MONTHLY_RENT", deposit: 1100, monthlyRent: 52, memo: "농협 도보 2분, 금융시설 접근 용이", lat: 36.4234, lng: 128.7345),
        MapProperty(id: 13, name: "의성우체국 옆 원룸", address: "경상북도 의성군 의성읍 우체국길 123", propertyType: "ONE_ROOM", floor: 1, builtYear: 2020, area: 18, marketPrice: 15500, leaseType: "JEONSE", deposit: 2800, monthlyRent: nil, memo: "우체국 도보 1분, 생활 편의시설 접근 용이", lat: 36.3456, lng: 128.6123),
        MapProperty(id: 14, name: "의성중학교 근처 오피스텔", address: "경상북도 의성군 의성읍 중학교길 456", propertyType: "OFFICETEL", floor: 4, builtYear: 2017, area: 23, marketPrice: 21000, leaseType: "MONTHLY_RENT", deposit: 850, monthlyRent: 48, memo: "중학교 인근, 학원가 접근 용이", lat: 36.3123, lng: 128.8012),
        MapProperty(id: 15, name: "의성파출소 앞 빌라", address: "경상북도 의성군 의성읍 파출소로 789", propertyType: "VILLA", floor: 2, builtYear: 2016, area: 25, marketPrice: 24000, leaseType: "JEONSE", deposit: 3500, monthlyRent: nil, memo: "파출소 인근, 안전한 주거 환경", lat: 36.3678, lng: 128.5890),
        MapProperty(id: 16, name: "의성시외버스정류장 근처 원룸", address: "경상북도 의성군 의성읍 버스로 234", propertyType: "ONE_ROOM", floor: 3, builtYear: 2018, area: 20, marketPrice: 16500, leaseType: "MONTHLY_RENT", deposit: 550, monthlyRent: 38, memo: "버스정류장 도보 3분, 교통 편리", lat: 36.2890, lng: 128.7234),
        MapProperty(id: 17, name: "의성공원 옆 아파트", address: "경상북도 의성군 의성읍 공원로 567", propertyType: "APARTMENT", floor: 3, builtYear: 2013, area: 29, marketPrice: 29000, leaseType: "MONTHLY_RENT", deposit: 1300, monthlyRent: 58, memo: "공원 인근, 산책하기 좋은 환경", lat: 36.4123, lng: 128.6678),
        MapProperty(id: 18, name: "의성시장 뒷골목 빌라", address: "경상북도 의성군 의성읍 뒷골목길 890", propertyType: "VILLA", floor: 1, builtYear: 2015, area: 24, marketPrice: 23000, leaseType: "MONTHLY_RENT", deposit: 1000, monthlyRent: 48, memo: "시장 인근, 생활 편의시설 접근 용이", lat: 36.3345, lng: 128.7567),
        MapProperty(id: 19, name: "의성초등학교 앞 원룸", address: "경상북도 의성군 의성읍 초등앞길 123", propertyType: "ONE_ROOM", floor: 2, builtYear: 2019, area: 19, marketPrice: 16200, leaseType: "JEONSE", deposit: 3200, monthlyRent: nil, memo: "초등학교 도보 2분, 조용한 주거 환경", lat: 36.3012, lng: 128.6345),
        MapProperty(id: 20, name: "의성보건지소 근처 오피스텔", address: "경상북도 의성군 의성읍 보건지소로 456", propertyType: "OFFICETEL", floor: 5, builtYear: 2020, area: 25, marketPrice: 23000, leaseType: "MONTHLY_RENT", deposit: 950, monthlyRent: 52, memo: "보건지소 인근, 의료시설 접근 용이", lat: 36.3789, lng: 128.8123),
        MapProperty(id: 21, name: "의성읍 주민센터 옆 빌라", address: "경상북도 의성군 의성읍 주민센터로 789", propertyType: "VILLA", floor: 3, builtYear: 2017, area: 28, marketPrice: 27500, leaseType: "MONTHLY_RENT", deposit: 1150, monthlyRent: 54, memo: "주민센터 도보 3분, 행정기관 접근 용이", lat: 36.2567, lng: 128.6890),
        MapProperty(id: 22, name: "의성역사박물관 근처 원룸", address: "경상북도 의성군 의성읍 박물관로 234", propertyType: "ONE_ROOM", floor: 1, builtYear: 2016, area: 17, marketPrice: 14800, leaseType: "MONTHLY_RENT", deposit: 500, monthlyRent: 33, memo: "박물관 인근, 문화시설 접근 용이", lat: 36.4234, lng: 128.6012),
        MapProperty(id: 23, name: "의성종합운동장 앞 아파트", address: "경상북도 의성군 의성읍 운동장로 567", propertyType: "APARTMENT", floor: 4, builtYear: 2014, area: 31, marketPrice: 31000, leaseType: "JEONSE", deposit: 4800, monthlyRent: nil, memo: "운동장 도보 5분, 운동하기 좋은 환경", lat: 36.3456, lng: 128.7789),
        MapProperty(id: 24, name: "의성읍 경로당 옆 빌라", address: "경상북도 의성군 의성읍 경로당로 890", propertyType: "VILLA", floor: 2, builtYear: 2018, area: 26, marketPrice: 25000, leaseType: "MONTHLY_RENT", deposit: 1050, monthlyRent: 50, memo: "경로당 인근, 조용한 주거 환경", lat: 36.3123, lng: 128.5567),
        MapProperty(id: 25, name: "의성시장 입구 원룸", address: "경상북도 의성군 의성읍 시장입구로 123", propertyType: "ONE_ROOM", floor: 3, builtYear: 2021, area: 22, marketPrice: 18000, leaseType: "MONTHLY_RENT", deposit: 750, monthlyRent: 45, memo: "시장 입구 위치, 생활 편의시설 접근 용이", lat: 36.3890, lng: 128.7234),
        MapProperty(id: 26, name: "의성고등학교 뒷길 오피스텔", address: "경상북도 의성군 의성읍 고등뒷길 456", propertyType: "OFFICETEL", floor: 6, builtYear: 2019, area: 26, marketPrice: 24000, leaseType: "MONTHLY_RENT", deposit: 1000, monthlyRent: 55, memo: "고등학교 인근, 학원가 접근 용이", lat: 36.2678, lng: 128.7456),
        MapProperty(id: 27, name: "의성읍사무소 뒷골목 빌라", address: "경상북도 의성군 의성읍 읍사무소뒷길 789", propertyType: "VILLA", floor: 1, builtYear: 2015, area: 23, marketPrice: 22000, leaseType: "JEONSE", deposit: 3800, monthlyRent: nil, memo: "읍사무소 인근, 조용한 주거 환경", lat: 36.4012, lng: 128.6234),
        MapProperty(id: 28, name: "의성보건소 앞 원룸", address: "경상북도 의성군 의성읍 보건소앞로 234", propertyType: "ONE_ROOM", floor: 2, builtYear: 2017, area: 18, marketPrice: 15800, leaseType: "MONTHLY_RENT", deposit: 580, monthlyRent: 36, memo: "보건소 도보 1분, 의료시설 접근 용이", lat: 36.3345, lng: 128.6678),
        MapProperty(id: 29, name: "의성공용버스터미널 옆 아파트", address: "경상북도 의성군 의성읍 터미널옆로 567", propertyType: "APARTMENT", floor: 5, builtYear: 2012, area: 33, marketPrice: 33000, leaseType: "MONTHLY_RENT", deposit: 1600, monthlyRent: 65, memo: "터미널 도보 1분, 교통 매우 편리", lat: 36.2789, lng: 128.8012),
        MapProperty(id: 30, name: "의성농협 뒷골목 빌라", address: "경상북도 의성군 의성읍 농협뒷길 890", propertyType: "VILLA", floor: 3, builtYear: 2016, area: 27, marketPrice: 26500, leaseType: "MONTHLY_RENT", deposit: 1080, monthlyRent: 51, memo: "농협 인근, 금융시설 접근 용이", lat: 36.3567, lng: 128.5890),
        MapProperty(id: 31, name: "의성우체국 근처 원룸", address: "경상북도 의성군 의성읍 우체국근처로 123", propertyType: "ONE_ROOM", floor: 1, builtYear: 2020, area: 19, marketPrice: 16000, leaseType: "JEONSE", deposit: 3000, monthlyRent: nil, memo: "우체국 도보 2분, 생활 편의시설 접근 용이", lat: 36.4123, lng: 128.7123),
        MapProperty(id: 32, name: "의성중학교 앞 오피스텔", address: "경상북도 의성군 의성읍 중학교앞로 456", propertyType: "OFFICETEL", floor: 4, builtYear: 2018, area: 24, marketPrice: 21500, leaseType: "MONTHLY_RENT", deposit: 880, monthlyRent: 47, memo: "중학교 도보 2분, 학원가 접근 용이", lat: 36.3012, lng: 128.6789),
        MapProperty(id: 33, name: "의성파출소 옆 빌라", address: "경상북도 의성군 의성읍 파출소옆로 789", propertyType: "VILLA", floor: 2, builtYear: 2014, area: 25, marketPrice: 23500, leaseType: "JEONSE", deposit: 3600, monthlyRent: nil, memo: "파출소 도보 1분, 안전한 주거 환경", lat: 36.3678, lng: 128.7567),
        MapProperty(id: 34, name: "의성시외버스정류장 앞 원룸", address: "경상북도 의성군 의성읍 버스앞로 234", propertyType: "ONE_ROOM", floor: 3, builtYear: 2019, area: 21, marketPrice: 16800, leaseType: "MONTHLY_RENT", deposit: 620, monthlyRent: 40, memo: "버스정류장 도보 1분, 교통 매우 편리", lat: 36.2890, lng: 128.6456),
        MapProperty(id: 35, name: "의성공원 근처 아파트", address: "경상북도 의성군 의성읍 공원근처로 567", propertyType: "APARTMENT", floor: 3, builtYear: 2013, area: 30, marketPrice: 29500, leaseType: "MONTHLY_RENT", deposit: 1400, monthlyRent: 59, memo: "공원 도보 3분, 산책하기 좋은 환경", lat: 36.4234, lng: 128.6345),
        MapProperty(id: 36, name: "의성시장 골목 빌라", address: "경상북도 의성군 의성읍 시장골목로 890", propertyType: "VILLA", floor: 1, builtYear: 2016, area: 24, marketPrice: 22500, leaseType: "MONTHLY_RENT", deposit: 980, monthlyRent: 46, memo: "시장 골목 위치, 생활 편의시설 접근 용이", lat: 36.2567, lng: 128.8012),
        MapProperty(id: 37, name: "의성초등학교 뒷길 원룸", address: "경상북도 의성군 의성읍 초등뒷길 123", propertyType: "ONE_ROOM", floor: 2, builtYear: 2017, area: 18, marketPrice: 15600, leaseType: "JEONSE", deposit: 2900, monthlyRent: nil, memo: "초등학교 인근, 조용한 주거 환경", lat: 36.3456, lng: 128.5678),
        MapProperty(id: 38, name: "의성보건지소 앞 오피스텔", address: "경상북도 의성군 의성읍 보건지소앞로 456", propertyType: "OFFICETEL", floor: 5, builtYear: 2020, area: 25, marketPrice: 22500, leaseType: "MONTHLY_RENT", deposit: 920, monthlyRent: 49, memo: "보건지소 도보 2분, 의료시설 접근 용이", lat: 36.3789, lng: 128.7234),
        MapProperty(id: 39, name: "의성읍 주민센터 근처 빌라", address: "경상북도 의성군 의성읍 주민센터근처로 789", propertyType: "VILLA", floor: 3, builtYear: 2018, area: 28, marketPrice: 27000, leaseType: "MONTHLY_RENT", deposit: 1120, monthlyRent: 53, memo: "주민센터 도보 2분, 행정기관 접근 용이", lat: 36.3123, lng: 128.8123),
        MapProperty(id: 40, name: "의성역사박물관 옆 원룸", address: "경상북도 의성군 의성읍 박물관옆로 234", propertyType: "ONE_ROOM", floor: 1, builtYear: 2015, area: 17, marketPrice: 15000, leaseType: "MONTHLY_RENT", deposit: 520, monthlyRent: 32, memo: "박물관 도보 1분, 문화시설 접근 용이", lat: 36.4012, lng: 128.6890),
        MapProperty(id: 41, name: "의성종합운동장 옆 아파트", address: "경상북도 의성군 의성읍 운동장옆로 567", propertyType: "APARTMENT", floor: 4, builtYear: 2014, area: 32, marketPrice: 31500, leaseType: "JEONSE", deposit: 4900, monthlyRent: nil, memo: "운동장 도보 3분, 운동하기 좋은 환경", lat: 36.2678, lng: 128.6234),
        MapProperty(id: 42, name: "의성읍 경로당 앞 빌라", address: "경상북도 의성군 의성읍 경로당앞로 890", propertyType: "VILLA", floor: 2, builtYear: 2017, area: 26, marketPrice: 24500, leaseType: "MONTHLY_RENT", deposit: 1020, monthlyRent: 49, memo: "경로당 도보 1분, 조용한 주거 환경", lat: 36.3891, lng: 128.6678),
        MapProperty(id: 43, name: "의성시장 입구 옆 원룸", address: "경상북도 의성군 의성읍 시장입구옆로 123", propertyType: "ONE_ROOM", floor: 3, builtYear: 2021, area: 22, marketPrice: 17500, leaseType: "MONTHLY_RENT", deposit: 720, monthlyRent: 43, memo: "시장 입구 위치, 생활 편의시설 접근 용이", lat: 36.3345, lng: 128.6012),
        MapProperty(id: 44, name: "의성고등학교 앞 오피스텔", address: "경상북도 의성군 의성읍 고등앞로 456", propertyType: "OFFICETEL", floor: 6, builtYear: 2019, area: 26, marketPrice: 23500, leaseType: "MONTHLY_RENT", deposit: 980, monthlyRent: 54, memo: "고등학교 도보 1분, 학원가 접근 용이", lat: 36.3567, lng: 128.7789),
        MapProperty(id: 45, name: "의성읍사무소 앞 빌라", address: "경상북도 의성군 의성읍 읍사무소앞로 789", propertyType: "VILLA", floor: 1, builtYear: 2016, area: 23, marketPrice: 21500, leaseType: "JEONSE", deposit: 3700, monthlyRent: nil, memo: "읍사무소 도보 1분, 행정기관 접근 용이", lat: 36.2789, lng: 128.5567),
        MapProperty(id: 46, name: "의성보건소 뒷길 원룸", address: "경상북도 의성군 의성읍 보건소뒷길 234", propertyType: "ONE_ROOM", floor: 2, builtYear: 2018, area: 18, marketPrice: 15700, leaseType: "MONTHLY_RENT", deposit: 570, monthlyRent: 35, memo: "보건소 인근, 의료시설 접근 용이", lat: 36.4123, lng: 128.7456),
        MapProperty(id: 47, name: "의성공용버스터미널 뒷골목 아파트", address: "경상북도 의성군 의성읍 터미널뒷길 567", propertyType: "APARTMENT", floor: 5, builtYear: 2011, area: 34, marketPrice: 34000, leaseType: "MONTHLY_RENT", deposit: 1700, monthlyRent: 68, memo: "터미널 인근, 교통 매우 편리", lat: 36.3012, lng: 128.8234),
        MapProperty(id: 48, name: "의성농협 앞 빌라", address: "경상북도 의성군 의성읍 농협앞로 890", propertyType: "VILLA", floor: 3, builtYear: 2015, area: 27, marketPrice: 26000, leaseType: "MONTHLY_RENT", deposit: 1070, monthlyRent: 50, memo: "농협 도보 1분, 금융시설 접근 용이", lat: 36.3678, lng: 128.6123),
        MapProperty(id: 49, name: "의성우체국 뒷골목 원룸", address: "경상북도 의성군 의성읍 우체국뒷길 123", propertyType: "ONE_ROOM", floor: 1, builtYear: 2019, area: 19, marketPrice: 15900, leaseType: "JEONSE", deposit: 3100, monthlyRent: nil, memo: "우체국 인근, 생활 편의시설 접근 용이", lat: 36.4234, lng: 128.6789),
        MapProperty(id: 50, name: "의성중학교 뒷길 오피스텔", address: "경상북도 의성군 의성읍 중학교뒷길 456", propertyType: "OFFICETEL", floor: 4, builtYear: 2017, area: 23, marketPrice: 20800, leaseType: "MONTHLY_RENT", deposit: 870, monthlyRent: 46, memo: "중학교 인근, 학원가 접근 용이", lat: 36.2567, lng: 128.6345)
    ]
    
    func selectProperty(_ property: MapProperty) {
        selectedProperty = property
        centerLat = property.lat
        centerLng = property.lng
        isDetailPresented = true
    }
    
    func closeDetail() {
        isDetailPresented = false
    }
}
