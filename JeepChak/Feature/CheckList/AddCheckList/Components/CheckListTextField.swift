//
//  CheckListTextField.swift
//  JeepChak
//
//  Created by 김은찬 on 10/28/25.
//

import SwiftUI

struct CheckListTextField: View {
    var label: String
    @Binding var text: String
    var isFocused: Bool
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .foregroundColor(.gray)
                .font(.system(size: 14))

            TextField("", text: $text)
                .keyboardType(keyboardType)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .padding(.vertical, 4)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(isFocused ? .cyan : .gray.opacity(0.3))
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}
