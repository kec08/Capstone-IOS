//
//  LoanGuideStep5View.swift
//  JeepChak
//
//  Created by 김은찬 on 12/21/25.
//

import SwiftUI

struct LoanGuideStep5View: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LoanGuideViewModel.shared
    @State private var navigateToLoading = false
    
    @State private var hasLeaseAgreement: Bool? = nil
    @State private var selectedFixedDateStatus: FixedDateStatus? = nil
    
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
                            Text("5/5단계")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            ProgressView(value: 1.0)
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
                            Text("계약 정보를 입력해주세요")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("선택 사항이지만 입력하시면 더 정확한 안내가 가능합니다")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // 임대차계약서 유무
                        VStack(alignment: .leading, spacing: 12) {
                            Text("임대차계약서 유무")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            HStack(spacing: 12) {
                                SegmentedButton(
                                    title: "있음",
                                    isSelected: hasLeaseAgreement == true
                                ) {
                                    hasLeaseAgreement = true
                                }
                                
                                SegmentedButton(
                                    title: "없음 (예정)",
                                    isSelected: hasLeaseAgreement == false
                                ) {
                                    hasLeaseAgreement = false
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 확정일자 여부
                        VStack(alignment: .leading, spacing: 12) {
                            Text("확정일자 여부")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            HStack(spacing: 12) {
                                ForEach(FixedDateStatus.allCases, id: \.self) { status in
                                    SegmentedButton(
                                        title: status.rawValue,
                                        isSelected: selectedFixedDateStatus == status
                                    ) {
                                        selectedFixedDateStatus = status
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 계약 관련 체크리스트
                        VStack(alignment: .leading, spacing: 12) {
                            Text("계약 관련 체크리스트")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                LoanGuideChecklistItem(text: "예상 대출 가능 금액")
                                LoanGuideChecklistItem(text: "등기부등본 확인 (선순위 권리)")
                                LoanGuideChecklistItem(text: "확정일자 받기 (주민센터 또는 인터넷)")
                                LoanGuideChecklistItem(text: "전입신고 하기 (계약 체결 후)")
                            }
                            .padding(14)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        // 안내 문구
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lightbulb")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Text("확정일자는 전세대출 실행에 필수적인 절차입니다")
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
            .navigationDestination(isPresented: $navigateToLoading) {
                LoanGuideLoadingView()
            }
            .safeAreaInset(edge: .bottom) {
                Button(action: {
                    // 데이터 저장
                    viewModel.data.hasLeaseAgreement = hasLeaseAgreement
                    viewModel.data.fixedDateStatus = selectedFixedDateStatus
                    viewModel.saveData()
                    
                    navigateToLoading = true
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
                .padding(.bottom, 30)
                .background(Color.white)
            }
        }
    }
}

struct LoanGuideChecklistItem: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 16))
                .foregroundColor(Color("customBlue"))
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.black)
            
            Spacer()
        }
    }
}

#Preview {
    LoanGuideStep5View()
}

