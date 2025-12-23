//
//  LoanGuideResultView.swift
//  JeepChak
//
//  Created by 김은찬 on 12/21/25.
//

import SwiftUI

struct LoanGuideResultView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = LoanGuideViewModel.shared
    let source: LoanGuideSource
    
    init(source: LoanGuideSource = .home) {
        self.source = source
    }
    
    // 임시 데이터
    private let mockResult = LoanGuideResult(
        estimatedLoanAmount: 20000,
        estimatedInterestRate: 2.8,
        selfFunded: 5000,
        monthlyInterest: 47,
        managementFee: 12,
        totalMonthlyPayment: 59,
        recommendedProducts: [
            RecommendedProduct(
                title: "청년 전월세보증금 대출",
                isRecommended: true,
                fund: "주택도시기금",
                limit: "한도: 최대 1억원",
                interestRate: "금리: 연 1.8-2.4%",
                benefits: [
                    "만 19~34세 무주택자",
                    "보증금의 80% 이내",
                    "저금리 혜택"
                ]
            ),
            RecommendedProduct(
                title: "일반 전세자금대출",
                isRecommended: false,
                fund: "은행권",
                limit: "한도: 보증금의 70~80%",
                interestRate: "금리: 연 3.0~4.5%",
                benefits: [
                    "주택기금 대상 외 일반대출",
                    "신용등급에 따라 금리 차등"
                ]
            )
        ],
        applicationSteps: [
            ApplicationStep(
                number: 1,
                title: "대출 상담 및 상품 선택",
                description: "은행 앱 또는 영업점 방문하여 상담"
            ),
            ApplicationStep(
                number: 2,
                title: "필요 서류 준비",
                description: "신분증, 재직증명서\n소득증명 서류\n임대차계약서 사본\n등기부등본"
            ),
            ApplicationStep(
                number: 3,
                title: "대출 심사 및 승인",
                description: "신용평가 및 소득 심사 (2-3 영업일 소요)"
            ),
            ApplicationStep(
                number: 4,
                title: "계약 체결 및 전입신고",
                description: "임대차계약 체결 후 전입신고 및 확정일자 받기"
            ),
            ApplicationStep(
                number: 5,
                title: "대출 실행",
                description: "임대인 계좌로 대출금 입금"
            )
        ],
        applicationChannels: [
            "은행 모바일 앱: KB국민, 신한, 우리, 하나 등",
            "은행 영업점 방문: 상담 후 신청",
            "기금든든 (주택도시기금): 청년·신혼부부 전용 상품"
        ],
        prerequisiteChecklist: [
            PrerequisiteItem(
                title: "확정일자 받기",
                description: "계약 체결 후 주민센터 또는 인터넷으로 신청"
            ),
            PrerequisiteItem(
                title: "전입신고",
                description: "계약일 또는 잔금일 이후에 신고"
            ),
            PrerequisiteItem(
                title: "임대차계약서 및 계약금 영수증",
                description: "대출 신청 시 필수 서류"
            )
        ]
    )
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    // 헤더 (흰색 배경)
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.customBlack)
                        }
                        
                        Spacer()
                        
                        Text("대출 가이드 결과")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.customBlack)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.clear)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .background(Color.customWhite)
                    
                    VStack(spacing: 24) {
                        // 맞춤 대출 가이드 결과
                        VStack(alignment: .leading, spacing: 30) {
                            Text("맞춤 대출 가이드 결과")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.customWhite)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("예상 대출 가능 금액")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.9))
                                    
                                    Text("\(formatNumber(mockResult.estimatedLoanAmount))만원")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.customWhite)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 10) {
                                    Text("예상 금리")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.9))
                                    Text("연 \(mockResult.estimatedInterestRate)%")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.customWhite)
                                }
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color("customBlue"))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.top, 40)
                        
                        // 예상 지불 비용
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 0) {
                                Image(systemName: "calculator")
                                    .font(.system(size: 16))
                                    .foregroundColor(.customBlack)
                                Text("예상 지불 비용")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.customBlack)
                                    .padding(.bottom, 8)
                            }
                            
                            VStack(spacing: 12) {
                                CostRow(title: "자기 자금", amount: "\(formatNumber(mockResult.selfFunded))만원")
                                CostRow(title: "월 이자 (예상)", amount: "\(mockResult.monthlyInterest)만원")
                                CostRow(title: "관리비", amount: "\(mockResult.managementFee)만원")
                                
                                Divider()
                                
                                HStack {
                                    Text("월 총 부담 금액")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.customBlack)
                                    Spacer()
                                    Text("약 \(mockResult.totalMonthlyPayment)만원")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color.customBlue)
                                }
                                .padding(.top, 14)
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        
                        // 추천 대출 상품
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 8) {
                                Image(systemName: "doc.text")
                                    .font(.system(size: 18))
                                    .foregroundColor(.customBlack)
                                    .padding(.bottom, 10)
                                
                                Text("추천 대출 상품")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.customBlack)
                                    .padding(.bottom, 10)
                            }
                            
                            ForEach(mockResult.recommendedProducts, id: \.title) { product in
                                RecommendedProductCard(product: product)
                            }
                        }
                        .padding(20)
                        .background(Color.customWhite)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        
                        // 신청 절차 및 방법
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 8) {
                                Image(systemName: "doc.text")
                                    .font(.system(size: 16))
                                    .foregroundColor(.customBlack)
                                    .padding(.bottom, 12)
                                
                                Text("신청 절차 및 방법")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.customBlack)
                                    .padding(.bottom, 12)
                            }
                            
                            VStack(spacing: 16) {
                                ForEach(mockResult.applicationSteps, id: \.number) { step in
                                    ApplicationStepRow(step: step)
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        
                        // 신청 가능 채널
                        VStack(alignment: .leading, spacing: 16) {
                            Text("신청 가능 채널")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.customBlack)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(mockResult.applicationChannels, id: \.self) { channel in
                                    HStack(spacing: 8) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color("customBlue"))
                                        Text(channel)
                                            .font(.system(size: 14))
                                            .foregroundColor(.customBlack)
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.gray.opacity(0.07))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        
                        // 선행 조건 체크리스트
                        VStack(alignment: .leading, spacing: 16) {
                            Text("선행 조건 체크리스트")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.customBlack)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(mockResult.prerequisiteChecklist, id: \.title) { item in
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(Color("customBlue"))
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(item.title)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.customBlack)
                                            Text(item.description)
                                                .font(.system(size: 14))
                                                .foregroundColor(.customGray300)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        
                        // 유의사항
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.orange)
                                Text("유의사항")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.customBlack)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("• 본 결과는 예상 수치로 실제 대출 조건과 다를 수 있습니다.")
                                Text("• 대출 승인 여부는 금융기관의 심사 결과에 따라 결정됩니다.")
                                Text("• 과도한 대출은 개인 신용등급 하락의 원인이 될 수 있습니다.")
                                Text("• 대출 조건은 2025년 12월 기준이며 변동될 수 있습니다.")
                            }
                            .font(.system(size: 13))
                            .foregroundColor(.customGray300)
                        }
                        .padding(16)
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                        
                        // 결과 확인 버튼
                        Button(action: {
                            // 홈에서 왔으면 홈으로, 마이에서 왔으면 마이로
                            // NavigationStack을 모두 pop하기 위해 dismiss를 여러 번 호출
                            if source == .home {
                                // 홈으로 돌아가기
                                presentationMode.wrappedValue.dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } else {
                                // 마이로 돌아가기
                                presentationMode.wrappedValue.dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }) {
                            Text("결과 확인")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(Color("customBlue"))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
    }
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

struct CostRow: View {
    let title: String
    let amount: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
            Text(amount)
                .font(Font.system(size: 14, weight: .medium))
                .foregroundColor(.customBlack)
        }
    }
}

struct RecommendedProductCard: View {
    let product: RecommendedProduct
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(product.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.customBlack)
                
                if product.isRecommended {
                    Text("추천")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("customBlue"))
                        .cornerRadius(5)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.fund)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text(product.limit)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text(product.interestRate)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(product.benefits, id: \.self) { benefit in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        Text(benefit)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.gray.opacity(0.05) as Color)
        .cornerRadius(12)
    }
}

struct ApplicationStepRow: View {
    let step: ApplicationStep
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color("customBlue"))
                    .frame(width: 28, height: 28)
                
                Text("\(step.number)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.customWhite)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(step.title)
                    .font(Font.system(size: 16, weight: .medium))
                    .foregroundColor(.customBlack)
                
                Text(step.description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineSpacing(4)
            }
            
            Spacer()
        }
    }
}

// 데이터 모델
struct LoanGuideResult {
    let estimatedLoanAmount: Int
    let estimatedInterestRate: Double
    let selfFunded: Int
    let monthlyInterest: Int
    let managementFee: Int
    let totalMonthlyPayment: Int
    let recommendedProducts: [RecommendedProduct]
    let applicationSteps: [ApplicationStep]
    let applicationChannels: [String]
    let prerequisiteChecklist: [PrerequisiteItem]
}

struct RecommendedProduct {
    let title: String
    let isRecommended: Bool
    let fund: String
    let limit: String
    let interestRate: String
    let benefits: [String]
}

struct ApplicationStep {
    let number: Int
    let title: String
    let description: String
}

struct PrerequisiteItem {
    let title: String
    let description: String
}


struct LoanGuideResultView_Previews: PreviewProvider {
    static var previews: some View {
            LoanGuideResultView()
    }
}

