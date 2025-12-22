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
    
    init(source: LoanGuideSource = .home) {
        self.source = source
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 배경
                Color.white
                    .ignoresSafeArea()
                
                if isLoading {
                    // 로딩 화면
                    VStack(spacing: 30) {
                        // 로딩 아이콘
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color("customBlue"),
                                            Color.cyan,
                                            Color.yellow
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .blur(radius: 20)
                                .opacity(0.8)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text("AI가 최적의 대출 가이드를\n생성하는 중입니다...")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.customBlack)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                } else {
                    // 로딩 완료 후 결과 화면으로 이동
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToResult) {
                LoanGuideResultView(source: source)
            }
            .onAppear {
                // 3초 후 로딩 완료
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isLoading = false
                    navigateToResult = true
                }
            }
        }
    }
}

#Preview {
    LoanGuideLoadingView()
}

