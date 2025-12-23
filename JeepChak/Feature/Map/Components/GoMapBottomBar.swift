//
//  GoMapBottomBar.swift
//  Eodigo
//
//  Created by 김은찬 on 12/19/25.
//

import SwiftUI

struct GoMapBottomBar: View {
    let onAI: () -> Void
    let onStart: () -> Void
    let onWallet: () -> Void

    var body: some View {
        VStack {
            Spacer()

            HStack(spacing: 24) {
                circleButton(title: "AI", system: nil, action: onAI)
                bigStartButton(action: onStart)
                circleButton(title: nil, system: "creditcard", action: onWallet)
            }
            .padding(.bottom, 40)
            .padding(.top, 20)
        }
    }

    private func circleButton(title: String?, system: String?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 64, height: 64)
                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)

                if let title {
                    Text(title)
                        .font(SwiftUI.Font.system(size: 18, weight: .bold))
                        .foregroundColor(.blue)
                } else if let system {
                    Image(systemName: system)
                        .font(SwiftUI.Font.system(size: 20, weight: .semibold))
                        .foregroundColor(SwiftUI.Color("customBlue"))
                }
            }
        }
    }

    private func bigStartButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.yellow.opacity(0.95))
                    .frame(width: 92, height: 92)
                    .shadow(color: Color.black.opacity(0.10), radius: 12, x: 0, y: 6)

                Text("출발")
                    .font(SwiftUI.Font.system(size: 20, weight: .bold))
                    .foregroundColor(SwiftUI.Color("customBlue"))
            }
        }
    }
}
