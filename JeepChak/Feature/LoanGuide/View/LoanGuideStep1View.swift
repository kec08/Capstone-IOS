//
//  LoanGuideStep1View.swift
//  JeepChak
//
//  Created by 김은찬 on 12/21/25.
//

import SwiftUI

struct LoanGuideStep1View: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LoanGuideViewModel.shared
    @State private var navigateToStep2 = false
    let source: LoanGuideSource
    
    @State private var age: String = ""
    @State private var isHeadOfHousehold: Bool? = nil
    @State private var selectedFamilyComposition: FamilyComposition? = nil
    
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
                            .frame(width: 120)
                        
                        Text("사용자 정보")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.customBlack)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("1/5단계")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            ProgressView(value: 0.2)
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
                            Text("기본 정보를 입력해주세요")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.customBlack)
                            
                            Text("정확한 대출 가이드를 위해 필요한 정보입니다")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // 나이 입력
                        VStack(alignment: .leading, spacing: 12) {
                            Text("나이")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.customBlack)

                            ZStack(alignment: .leading) {
                                if age.isEmpty {
                                    Text("만 나이를 입력해주세요")
                                        .foregroundStyle(Color.customGray300)
                                        .padding(.leading, 16)
                                }

                                TextField("", text: $age)
                                    .keyboardType(.numberPad)
                                    .padding(16)
                                    .foregroundStyle(.customBlack)
                                    .tint(.customBlack)
                            }
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)

                        
                        // 세대주 여부
                        VStack(alignment: .leading, spacing: 12) {
                            Text("세대주 여부")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)
                            
                            HStack(spacing: 12) {
                                SegmentedButton(
                                    title: "예",
                                    isSelected: isHeadOfHousehold == true
                                ) {
                                    isHeadOfHousehold = true
                                }
                                
                                SegmentedButton(
                                    title: "아니오",
                                    isSelected: isHeadOfHousehold == false
                                ) {
                                    isHeadOfHousehold = false
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 가족 구성
                        VStack(alignment: .leading, spacing: 12) {
                            Text("가족 구성")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(FamilyComposition.allCases, id: \.self) { composition in
                                    SelectableButton(
                                        title: composition.rawValue,
                                        isSelected: selectedFamilyComposition == composition
                                    ) {
                                        selectedFamilyComposition = composition
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 안내 문구
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Text("청년 특례 대출은 만 19세~34세 이하 무주택자가 대상입니다")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // 다음 버튼 (스크롤 뷰 안에)
                        Button(action: {
                            // 데이터 저장
                            if let ageInt = Int(age) {
                                viewModel.data.age = ageInt
                            }
                            viewModel.data.isHeadOfHousehold = isHeadOfHousehold
                            viewModel.data.familyComposition = selectedFamilyComposition
                            
                            navigateToStep2 = true
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
            .navigationDestination(isPresented: $navigateToStep2) {
                LoanGuideStep2View(source: source)
            }
        }
    }
    
    private var isFormValid: Bool {
        !age.isEmpty && isHeadOfHousehold != nil && selectedFamilyComposition != nil
    }
}

struct SegmentedButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .customBlack)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(isSelected ? Color.customBlue : Color.gray.opacity(0.1))
                .cornerRadius(12)
        }
    }
}

struct SelectableButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(isSelected ? .white : .customBlack)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isSelected ? Color.customBlue : Color.gray.opacity(0.1))
                .cornerRadius(12)
        }
    }
}

#Preview {
    LoanGuideStep1View()
}
