//
//  AIGeneratedListView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/1/25.
//

import SwiftUI

struct AIGeneratedListView: View {
    var onConfirm: () -> Void

    let checklistItems = [
        "창문 틀에 곰팡이 여부 확인",
        "화장실 누수 흔적 확인",
        "보일러 작동 테스트",
        "주변 소음 확인"
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("AI가 생성한 체크리스트")
                .font(.system(size: 20, weight: .semibold))
                .padding(.top, 24)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(checklistItems, id: \.self) { item in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.cyan)
                            Text(item)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            Spacer()
                        }
                    }
                }
                .padding()
            }

            Button(action: onConfirm) {
                Text("확인")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cyan)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    AIGeneratedListView(onConfirm: {})
}
