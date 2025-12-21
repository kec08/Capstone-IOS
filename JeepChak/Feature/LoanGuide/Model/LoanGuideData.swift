//
//  LoanGuideData.swift
//  JeepChak
//
//  Created by 김은찬 on 12/21/25.
//

import Foundation

// 대출 가이드 설문 데이터 모델
struct LoanGuideData: Codable {
    // 1단계: 사용자 정보
    var age: Int?
    var isHeadOfHousehold: Bool?
    var familyComposition: FamilyComposition?
    
    // 2단계: 소득 정보
    var annualIncome: Int? // 만원 단위
    var monthlyIncome: Int? // 만원 단위
    var incomeType: IncomeType?
    var incomeCategory: IncomeCategory?
    
    // 3단계: 주거 정보
    var rentalArea: String?
    var houseType: HouseType?
    var leaseType: LoanGuideLeaseType?
    var deposit: Int? // 만원 단위
    var managementFee: Int? // 만원 단위
    var isLoanEligible: Bool?
    
    // 4단계: 신용 및 금융 정보
    var creditRating: CreditRating?
    var loanType: LoanType?
    var hasDelinquencyRecord: Bool?
    
    // 5단계: 계약 정보
    var hasLeaseAgreement: Bool?
    var fixedDateStatus: FixedDateStatus?
    
    init() {
        // 기본값으로 초기화
    }
}

enum FamilyComposition: String, Codable, CaseIterable {
    case single = "단독세대"
    case newlywed = "신혼"
    case couple = "부부"
    case youth = "청년"
}

enum IncomeType: String, Codable, CaseIterable {
    case employee = "직장인"
    case freelancer = "프리랜서"
    case selfEmployed = "자영업자"
}

enum IncomeCategory: String, Codable, CaseIterable {
    case earned = "근로소득"
    case business = "사업소득"
    case other = "기타소득"
}

enum HouseType: String, Codable, CaseIterable {
    case apartment = "아파트"
    case officetel = "오피스텔"
    case villa = "빌라"
}

enum LoanGuideLeaseType: String, Codable, CaseIterable {
    case jeonse = "전세"
    case monthly = "월세"
}

enum CreditRating: String, Codable, CaseIterable {
    case grade1 = "1등급"
    case grade2 = "2등급"
    case grade3 = "3등급"
    case grade4 = "4등급"
    case grade5 = "5등급"
    case grade6 = "6등급"
    case grade7 = "7등급"
    case grade8 = "8등급"
    case grade9 = "9등급"
    case grade10 = "10등급"
}

enum LoanType: String, Codable, CaseIterable {
    case credit = "신용대출"
    case jeonse = "전세대출"
    case mortgage = "주택담보대출"
    case other = "기타"
}

enum FixedDateStatus: String, Codable, CaseIterable {
    case received = "받음"
    case planned = "예정"
    case unknown = "모름"
}

