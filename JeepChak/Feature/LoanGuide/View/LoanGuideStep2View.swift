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
    
    @State private var annualIncome: String = ""
    @State private var monthlyIncome: String = ""
    @State private var selectedIncomeType: IncomeType? = nil
    @State private var selectedIncomeCategory: IncomeCategory? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // 헤더
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("2/5단계")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            ProgressView(value: 0.4)
                                .frame(width: 60)
                                .tint(.customBlue)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                    
                    // 콘텐츠
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("소득 정보를 입력해주세요")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                            
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
                                .foregroundColor(.black)
                            
                            TextField("예: 5000", text: $annualIncome)
                                .keyboardType(.numberPad)
                                .padding(16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        // 월소득
                        VStack(alignment: .leading, spacing: 12) {
                            Text("월 소득 (만원)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            TextField("예: 300", text: $monthlyIncome)
                                .keyboardType(.numberPad)
                                .padding(16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        // 소득 형태
                        VStack(alignment: .leading, spacing: 12) {
                            Text("소득 형태")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
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
                                .foregroundColor(.black)
                            
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
                    }
                    .padding(.bottom, 100)
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToStep3) {
                LoanGuideStep3View()
            }
            .safeAreaInset(edge: .bottom) {
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
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(isFormValid ? Color.customBlue : Color.gray.opacity(0.3))
                        .cornerRadius(12)
                }
                .disabled(!isFormValid)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                .background(Color.white)
            }
        }
    }
    
    private var isFormValid: Bool {
        !annualIncome.isEmpty && !monthlyIncome.isEmpty && selectedIncomeType != nil && selectedIncomeCategory != nil
    }
}

#Preview {
    LoanGuideStep2View()
}

