//
//  PropertyUploadErrorView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/26/25.
//

import SwiftUI

struct PropertyUploadErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red.opacity(0.7))
            
            Text("매물을 불러올 수 없습니다.")
                .font(.system(size: 18, weight: .bold))
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: onRetry) {
                Text("다시 시도")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 10)
                    .background(Color.cyan)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
            
            Spacer()
        }
    }
}


struct PropertyUploadErrorView_Previews: PreviewProvider {
    static var previews: some View {
            PropertyUploadErrorView(message: "네트워크 오류입니다.") { }
    }
}
