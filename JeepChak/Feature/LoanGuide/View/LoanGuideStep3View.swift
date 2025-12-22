//
//  LoanGuideStep3View.swift
//  JeepChak
//
//  Created by 김은찬 on 12/21/25.
//

import SwiftUI

struct LoanGuideStep3View: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LoanGuideViewModel.shared
    @State private var navigateToStep4 = false
    let source: LoanGuideSource
    
    @State private var rentalArea: String = ""
    @State private var selectedHouseType: HouseType? = nil
    @State private var selectedLeaseType: LoanGuideLeaseType? = nil
    @State private var deposit: String = ""
    @State private var managementFee: String = ""
    @State private var isLoanEligible: Bool? = nil
    
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
                        
                        Text("주거 정보")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.customBlack)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("3/5단계")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            ProgressView(value: 0.6)
                                .frame(width: 60)
                                .tint(Color("customBlue"))
                            
                            Text("60%")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .background(Color.customWhite)
                    
                    // 콘텐츠
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("주거 정보를 입력해주세요")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.customBlack)
                            
                            Text("임차할 주택의 정보입니다")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // 임차 지역
                        VStack(alignment: .leading, spacing: 12) {
                            Text("임차 지역")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)
                            
                            TextField("예: 서울시 강남구", text: $rentalArea)
                                .padding(16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.customBlack)
                        }
                        .padding(.horizontal, 20)
                        
                        // 집 유형
                        VStack(alignment: .leading, spacing: 12) {
                            Text("집 유형")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)
                            
                            HStack(spacing: 12) {
                                ForEach(HouseType.allCases, id: \.self) { type in
                                    SegmentedButton(
                                        title: type.rawValue,
                                        isSelected: selectedHouseType == type
                                    ) {
                                        selectedHouseType = type
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 전월세 형태
                        VStack(alignment: .leading, spacing: 12) {
                            Text("전월세 형태")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)
                            
                            HStack(spacing: 12) {
                                ForEach(LoanGuideLeaseType.allCases, id: \.self) { type in
                                    SegmentedButton(
                                        title: type.rawValue,
                                        isSelected: selectedLeaseType == type
                                    ) {
                                        selectedLeaseType = type
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 보증금
                        VStack(alignment: .leading, spacing: 12) {
                            Text("보증금 (만원)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)
                            
                            TextField("예: 20000", text: $deposit)
                                .keyboardType(.numberPad)
                                .padding(16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.customBlack)
                        }
                        .padding(.horizontal, 20)
                        
                        // 관리비
                        VStack(alignment: .leading, spacing: 12) {
                            Text("관리비 (만원)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)
                            
                            TextField("예: 10", text: $managementFee)
                                .keyboardType(.numberPad)
                                .padding(16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.customBlack)
                        }
                        .padding(.horizontal, 20)
                        
                        // 대출 가능 주택 여부
                        VStack(alignment: .leading, spacing: 12) {
                            Text("대출 가능 주택 여부")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)
                            
                            HStack(spacing: 12) {
                                SegmentedButton(
                                    title: "가능",
                                    isSelected: isLoanEligible == true
                                ) {
                                    isLoanEligible = true
                                }
                                
                                SegmentedButton(
                                    title: "불가능",
                                    isSelected: isLoanEligible == false
                                ) {
                                    isLoanEligible = false
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 안내 문구
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lightbulb")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Text("등기부등본의 표제부, 건축물대장을 통해 확인할 수 있습니다")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // 다음 버튼 (스크롤 뷰 안에)
                        Button(action: {
                            // 데이터 저장
                            viewModel.data.rentalArea = rentalArea.isEmpty ? nil : rentalArea
                            viewModel.data.houseType = selectedHouseType
                            viewModel.data.leaseType = selectedLeaseType
                            if let depositInt = Int(deposit) {
                                viewModel.data.deposit = depositInt
                            }
                            if let feeInt = Int(managementFee) {
                                viewModel.data.managementFee = feeInt
                            }
                            viewModel.data.isLoanEligible = isLoanEligible
                            
                            navigateToStep4 = true
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
            .navigationDestination(isPresented: $navigateToStep4) {
                LoanGuideStep4View(source: source)
            }
        }
    }
    
    private var isFormValid: Bool {
        !rentalArea.isEmpty && selectedHouseType != nil && selectedLeaseType != nil && !deposit.isEmpty && isLoanEligible != nil
    }
}

#Preview {
    LoanGuideStep3View()
}

