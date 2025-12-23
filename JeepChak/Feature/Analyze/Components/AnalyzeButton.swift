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
                .font(SwiftUI.Font.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .foregroundColor(enabled ? .white : .gray)
                .background(enabled ? SwiftUI.Color.customBlue : SwiftUI.Color.customGray100)
                .cornerRadius(12)
        }
        .disabled(!enabled)
    }
}


struct AnalyzeButton_Previews: PreviewProvider {
    static var previews: some View {
            VStack(spacing: 12) {
                AnalyzeButton(enabled: false, action: {})
                AnalyzeButton(enabled: true, action: {})
            }
            .padding()
    }
}
