//
//  PropertyUploadBottomButton.swift
//  JeepChak
//
//  Created by 김은찬 on 11/26/25.
//

import SwiftUI

struct PropertyUploadBottomButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .foregroundColor(isEnabled ? .customWhite : .customDarkGray)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isEnabled
                              ? .customBlue
                              : .customGray100)
                )
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    VStack {
        PropertyUploadBottomButton(title: "업로드 하기", isEnabled: false, action: {})
        PropertyUploadBottomButton(title: "업로드 하기", isEnabled: true, action: {})
    }
    .padding()
}
