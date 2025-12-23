//
//  LoanGuideLoadingView.swift
//  JeepChak
//
//  Created by 김은찬 on 12/21/25.
//

import SwiftUI

struct LoanGuideLoadingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LoanGuideViewModel.shared
    @State private var navigateToResult = false
    @State private var isLoading = true
    let source: LoanGuideSource
    
    var onComplete: () -> Void

    @State private var isAnimating = false

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
                // 3초 후 결과 페이지로 이동
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    navigateToResult = true
                }
            }
        }
    }
}

