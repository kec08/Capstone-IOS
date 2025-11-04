//
//  AddChecklistSheet.swift
//  JeepChak
//
//  Created by 김은찬 on 11/3/25.
//

import SwiftUI

struct AddChecklistSheet: View {
    @Binding var newItem: String
    var onAdd: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("체크리스트 항목 추가")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top, 20)
                    .foregroundColor(Color.customBlack)

                TextField("항목을 입력하세요", text: $newItem)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .foregroundColor(Color.customBlack)

                Spacer()

                HStack(spacing: 10) {
                    Button(action: onDismiss) {
                        Text("취소")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.customDarkGray)
                            .fontWeight(.semibold)
                    }

                    Button(action: onAdd) {
                        Text("추가")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.customBlue)
                            .foregroundColor(.customWhite)
                            .cornerRadius(8)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .background(Color.white)
        }
    }
}

