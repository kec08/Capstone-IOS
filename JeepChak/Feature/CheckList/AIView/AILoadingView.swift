//
//  AILoadingView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/1/25.
//

import SwiftUI

struct AILoadingView: View {
    var onComplete: () -> Void

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 16) {
            Image("AI_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 105, height: 105)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: isAnimating)

            Text("AI가 최적의 체크리스트를\n생성하는 중입니다…")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.customDarkGray)
                .lineLimit(5)
                .padding(.top, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                onComplete()
            }
        }
    }
}
