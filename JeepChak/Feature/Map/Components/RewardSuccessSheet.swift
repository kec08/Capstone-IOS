//
//  RewardSuccessSheet.swift
//  Eodigo
//
//  Created by 김은찬 on 12/20/25.
//

import SwiftUI

struct RewardSuccessSheet: View {
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            VStack(spacing: 8) {
                Text("인증완료!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                
                Text("토큰이 지급되었습니다")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: onClose) {
                Text("확인")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.customBlue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    RewardSuccessSheet(onClose: {})
}

