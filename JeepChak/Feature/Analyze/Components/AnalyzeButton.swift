//
//  AnalyzeButton.swift
//  JeepChak
//
//  Created by 김은찬 on 11/26/25.
//

import SwiftUI

struct AnalyzeButton: View {
    let enabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("분석 시작하기")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .foregroundColor(enabled ? .white : .gray)
                .background(enabled ? Color.customBlue : Color.customGray100)
                .cornerRadius(12)
        }
        .disabled(!enabled)
    }
}

#Preview {
    AnalyzeButton(enabled: false, action: {})
}
