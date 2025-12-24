//
//  LoanGuideLoadingView.swift
//  JeepChak
//
//  Created by 김은찬 on 12/21/25.
//

import SwiftUI

struct LoanGuideLoadingView: View {
    @Environment(\.dismiss) private var dismiss
    // 싱글톤 ObservableObject는 @StateObject가 아니라 @ObservedObject로 관찰하는 것이 안전합니다.
    @ObservedObject private var viewModel = LoanGuideViewModel.shared
    @State private var navigateToResult = false
    let source: LoanGuideSource
    
    var onComplete: () -> Void

    @State private var isAnimating = false
    @State private var hasRequested = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image("AI_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 105, height: 105)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: isAnimating)

                Text("AI가 최적의 대출 가이드를\n생성하는 중입니다…")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.customDarkGray)
                    .lineLimit(8)
                    .padding(.top, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToResult) {
                LoanGuideResultView(source: source)
            }
            .onAppear {
                isAnimating = true
                // 고정 3초 로딩 제거: API 응답이 오면 즉시 결과로 이동
                if !hasRequested {
                    hasRequested = true
                    viewModel.loanResult = nil
                    viewModel.requestLoanGuide()
                }
            }
            .onChange(of: viewModel.loanResult != nil) { hasResult in
                if hasResult {
                    navigateToResult = true
                }
            }
            .alert("대출 가이드 생성 실패", isPresented: $viewModel.showLoanErrorAlert) {
                Button("닫기", role: .cancel) {
                    dismiss()
                }
                Button("다시 시도") {
                    viewModel.loanErrorMessage = nil
                    viewModel.requestLoanGuide()
                }
            } message: {
                Text(viewModel.loanErrorMessage ?? "알 수 없는 오류가 발생했습니다.")
            }
        }
    }
}

