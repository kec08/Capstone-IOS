//
//  LoanGuideStep4View.swift
//  JeepChak
//
//  Created by 김은찬 on 12/21/25.
//

import SwiftUI

struct LoanGuideStep4View: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LoanGuideViewModel.shared
    @State private var navigateToStep5 = false
    
    @State private var selectedCreditRating: CreditRating? = nil
    @State private var selectedLoanType: LoanType? = nil
    @State private var hasDelinquencyRecord: Bool? = nil
    
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
                            Text("4/5단계")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            ProgressView(value: 0.8)
                                .frame(width: 60)
                                .tint(Color("customBlue"))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                    
                    // 콘텐츠
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("신용 및 금융 정보를 입력해주세요")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("대출 승인 및 금리 산정을 위한 정보입니다")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // 신용등급
                        VStack(alignment: .leading, spacing: 12) {
                            Text("신용등급")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            Menu {
                                ForEach(CreditRating.allCases, id: \.self) { rating in
                                    Button(action: {
                                        selectedCreditRating = rating
                                    }) {
                                        Text(rating.rawValue)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCreditRating?.rawValue ?? "선택해주세요")
                                        .foregroundColor(selectedCreditRating == nil ? .gray : .black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                .padding(16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 대출 종류
                        VStack(alignment: .leading, spacing: 12) {
                            Text("대출 종류")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            VStack(spacing: 12) {
                                ForEach(LoanType.allCases, id: \.self) { type in
                                    SelectableButton(
                                        title: type.rawValue,
                                        isSelected: selectedLoanType == type
                                    ) {
                                        selectedLoanType = type
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 연체 기록 여부
                        VStack(alignment: .leading, spacing: 12) {
                            Text("연체 기록 여부")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            HStack(spacing: 12) {
                                SegmentedButton(
                                    title: "없음",
                                    isSelected: hasDelinquencyRecord == false
                                ) {
                                    hasDelinquencyRecord = false
                                }
                                
                                SegmentedButton(
                                    title: "있음",
                                    isSelected: hasDelinquencyRecord == true
                                ) {
                                    hasDelinquencyRecord = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 안내 문구
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 14))
                                .foregroundColor(.orange)
                            
                            Text("연체 기록이 있는 경우 대출 승인이 어려울 수 있습니다")
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
            .navigationDestination(isPresented: $navigateToStep5) {
                LoanGuideStep5View()
            }
            .safeAreaInset(edge: .bottom) {
                Button(action: {
                    // 데이터 저장
                    viewModel.data.creditRating = selectedCreditRating
                    viewModel.data.loanType = selectedLoanType
                    viewModel.data.hasDelinquencyRecord = hasDelinquencyRecord
                    
                    navigateToStep5 = true
                }) {
                    Text("다음")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(isFormValid ? Color("customBlue") : Color.gray.opacity(0.3))
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
        selectedCreditRating != nil && selectedLoanType != nil && hasDelinquencyRecord != nil
    }
}

#Preview {
    LoanGuideStep4View()
}


