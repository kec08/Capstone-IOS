import SwiftUI

struct LoanGuideStep4View: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LoanGuideViewModel.shared
    @State private var navigateToStep5 = false

    let source: LoanGuideSource
    let onComplete: () -> Void

    @State private var selectedCreditRating: CreditRating? = nil
    @State private var selectedLoanType: LoanType? = nil
    @State private var hasDelinquencyRecord: Bool? = nil

    init(source: LoanGuideSource = .home, onComplete: @escaping () -> Void = {}) {
        self.source = source
        self.onComplete = onComplete
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.customBlack)
                        }

                        Spacer()
                            .frame(width: 100)

                        Text("신용 및 금융 정보")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.customBlack)

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
                    .padding(.bottom, 20)
                    .background(Color.customWhite)

                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("신용 및 금융 정보를 입력해주세요")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.customBlack)

                            Text("대출 승인 및 금리 산정을 위한 정보입니다")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("신용등급")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)

                            Menu {
                                ForEach(CreditRating.allCases, id: \.self) { rating in
                                    Button {
                                        selectedCreditRating = rating
                                    } label: {
                                        Text(rating.rawValue)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCreditRating?.rawValue ?? "선택해주세요")
                                        .foregroundColor(selectedCreditRating == nil ? .gray : .customBlack)
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

                        VStack(alignment: .leading, spacing: 12) {
                            Text("대출 종류")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)

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

                        VStack(alignment: .leading, spacing: 12) {
                            Text("연체 기록 여부")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.customBlack)

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

                        Button {
                            viewModel.data.creditRating = selectedCreditRating
                            viewModel.data.loanType = selectedLoanType
                            viewModel.data.hasDelinquencyRecord = hasDelinquencyRecord
                            navigateToStep5 = true
                        } label: {
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
            .navigationDestination(isPresented: $navigateToStep5) {
                LoanGuideStep5View(source: source, onComplete: onComplete)
            }
            // (선택) 이미 저장된 값이 있으면 화면 진입 시 복원하고 싶다면 아래 추가
            .onAppear {
                selectedCreditRating = viewModel.data.creditRating
                selectedLoanType = viewModel.data.loanType
                hasDelinquencyRecord = viewModel.data.hasDelinquencyRecord
            }
        }
    }

    private var isFormValid: Bool {
        selectedCreditRating != nil && selectedLoanType != nil && hasDelinquencyRecord != nil
    }
}
