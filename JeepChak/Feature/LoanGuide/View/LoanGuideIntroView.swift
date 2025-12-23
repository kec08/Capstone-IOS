//
//  LoanGuideIntroView.swift
//  JeepChak
//
//  Created by 김은찬 on 12/21/25.
//

import SwiftUI

enum LoanGuideSource {
    case home
    case my
}

struct LoanGuideIntroView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToStep1 = false
    let source: LoanGuideSource
    
    init(source: LoanGuideSource = .home) {
        self.source = source
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
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
                        
                        Text("대출 가이드")
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
                    
                    // 메인 콘텐츠
                    VStack(spacing: 24) {
                        // 타이틀
                        VStack(spacing: 12) {
                            Text("대출 가이드")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.customBlack)
                                .padding(.bottom, 6)
                            
                            Text("나에게 딱 맞춤 대출 가이드")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.gray)
                                .padding(.bottom, 4)
                            
                            Text("짧은 설문만으로 최적의 대출 정보를 찾아보세요!")
                                .font(.system(size: 15))
                                .foregroundColor(.gray.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        Image("Home_map")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 230, height: 180)
                            .padding(.vertical, 20)
                        
                        // 정보 섹션
                        VStack(alignment: .leading, spacing: 20) {
                            Text("이런 정보를 확인할 수 있어요")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.customBlack)
                                .padding(.bottom, 8)
                            
                            LoanGuideInfoRow(
                                icon: "chart.bar",
                                title: "예상 대출 금액 계산",
                                description: "내 조건으로 받을 수 있는 대출 한도와 금리를 확인해요"
                            )
                            
                            LoanGuideInfoRow(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "맞춤형 상품 추천",
                                description: "청년, 신혼부부 등 나에게 유리한 대출 상품을 추천해요"
                            )
                            
                            LoanGuideInfoRow(
                                icon: "doc.text",
                                title: "신청 절차 안내",
                                description: "필요 서류부터 대출 실행까지 단계별로 알려드려요"
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // 안내 문구
                        VStack(spacing: 8) {
                            Text("간단한 정보만 입력하면 5분 안에 결과를 확인할 수 있어요.")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                            
                            Text("수집된 정보는 저장되지 않으니 안심하세요.")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        
                        // 시작하기 버튼 (스크롤 뷰 안에)
                        Button(action: {
                            navigateToStep1 = true
                        }) {
                            Text("시작하기")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.customWhite)
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
            .navigationDestination(isPresented: $navigateToStep1) {
                LoanGuideStep1View(source: source)
            }
        }
    }
}

struct LoanGuideInfoRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color("customBlue"))
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.customBlack)
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineSpacing(2)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    LoanGuideIntroView()
}
