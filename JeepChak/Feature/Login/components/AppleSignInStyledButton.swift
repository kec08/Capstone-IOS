//
//  AppleSignInStyledButton.swift
//  JeepChak
//
//  Created by 김은찬 on 11/29/25.
//

import SwiftUI

struct AppleSignInStyledButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "applelogo")
                    .font(.system(size: 20, weight: .regular))

                Text("Apple 계정으로 로그인/회원가입")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.customBlack)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.customBlack, lineWidth: 1)
                    .background(Color.customBackgroundWhite.cornerRadius(8))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AppleSignInStyledButton { }
        .padding()
        .background(.customWhite)
}
