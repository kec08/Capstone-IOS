//
//  LoanGuideStep2View.swift
//  JeepChak
//
//  Created by 김은찬 on 12/21/25.
//

import SwiftUI

struct LoanGuideStep2View: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LoanGuideViewModel.shared
    @State private var navigateToStep3 = false
    let source: LoanGuideSource
    
    @State private var annualIncome: String = ""
    @State private var monthlyIncome: String = ""
    @State private var selectedIncomeType: IncomeType? = nil
    @State private var selectedIncomeCategory: IncomeCategory? = nil
    
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
                            .frame(width: 130)
                        
                        Text("소득 정보")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.customBlack)
                        
                        Spacer()
                            
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("2/5단계")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            ProgressView(value: 0.4)
                                .frame(width: 60)
                                .tint(Color("customBlue"))
                            
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .background(Color.customWhite)
                    
                    // 콘텐츠
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("소득 정보를 입력해주세요")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.customBlack)
                            
                            Text("대출 한도 산정을 위한 정보입니다")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // 연소득
                        VStack(alignment: .leading, spacing: 12) {
                            Text("연소득 (만원)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.customBlack)

                            ZStack(alignment: .leading) {
                                if annualIncome.isEmpty {
                                    Text("예: 5000")
                                        .foregroundStyle(Color.customGray300)
                                        .padding(.leading, 16)
                                }

                                TextField("", text: $annualIncome)
                                    .keyboardType(.numberPad)
                                    .padding(16)
                                    .foregroundStyle(.customBlack)
                                    .tint(.customBlack)
                            }
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)

                        
                        // 월소득
                        VStack(alignment: .leading, spacing: 12) {
                            Text("월 소득 (만원)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.customBlack)

                            ZStack(alignment: .leading) {
                                if monthlyIncome.isEmpty {
                                    Text("예: 300")
                                        .foregroundStyle(Color.customGray300)
                                        .padding(.leading, 16)
                                }

                                TextField("", text: $monthlyIncome)
                                    .keyboardType(.numberPad)
                                    .padding(16)
                                    .foregroundStyle(.customBlack)
                                    .tint(.customBlack)
                            }
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)

                        // 소득 형태
                        VStack(alignment: .leading, spacing: 12) {
                            Text("소득 형태")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)
                            
                            HStack(spacing: 12) {
                                ForEach(IncomeType.allCases, id: \.self) { type in
                                    SelectableButton(
                                        title: type.rawValue,
                                        isSelected: selectedIncomeType == type
                                    ) {
                                        selectedIncomeType = type
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 소득 종류
                        VStack(alignment: .leading, spacing: 12) {
                            Text("소득 종류")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)
                            
                            HStack(spacing: 12) {
                                ForEach(IncomeCategory.allCases, id: \.self) { category in
                                    SelectableButton(
                                        title: category.rawValue,
                                        isSelected: selectedIncomeCategory == category
                                    ) {
                                        selectedIncomeCategory = category
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 안내 문구
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lightbulb")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Text("소득 증빙 서류: 재직증명서, 급여명세서, 소득금액증명원 등이 필요합니다")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // 다음 버튼 (스크롤 뷰 안에)
                        Button(action: {
                            // 데이터 저장
                            if let annual = Int(annualIncome) {
                                viewModel.data.annualIncome = annual
                            }
                            if let monthly = Int(monthlyIncome) {
                                viewModel.data.monthlyIncome = monthly
                            }
                            viewModel.data.incomeType = selectedIncomeType
                            viewModel.data.incomeCategory = selectedIncomeCategory
                            
                            navigateToStep3 = true
                        }) {
                            Text("다음")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.customWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(isFormValid ? Color("customBlue") : Color.gray.opacity(0.3))
                                .cornerRadius(12)
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToStep3) {
                LoanGuideStep3View(source: source)
            }
        }
    }
    
    private var isFormValid: Bool {
        !annualIncome.isEmpty && !monthlyIncome.isEmpty && selectedIncomeType != nil && selectedIncomeCategory != nil
    }
}


struct LoanGuideStep2View_Previews: PreviewProvider {
    static var previews: some View {
            LoanGuideStep2View()
    }
}

