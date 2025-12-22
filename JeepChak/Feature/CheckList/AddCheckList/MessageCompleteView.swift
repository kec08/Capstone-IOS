//
//  MessageCompleteView.swift
//  JeepChak
//
//  Created by 김은찬 on 12/16/25.
//

import SwiftUI

struct MessageCompleteView: View {
    let message: String
    let onConfirm: () -> Void

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 14) {
                // 아이콘은 원하는 이미지/로고로 바꾸세요
                Image(systemName: "sparkles")
                    .font(.system(size: 54))
                    .padding(.bottom, 6)

                Text(message.isEmpty ? "완료되었습니다" : message)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.customBlack)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            Button(action: onConfirm) {
                Text("확인")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.cyan)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
        }
        .background(Color.white.ignoresSafeArea())
    }
}
