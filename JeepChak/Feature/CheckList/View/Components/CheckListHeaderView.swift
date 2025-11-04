//
//  CheckListHeaderView.swift
//  JeepChak
//
//  Created by 김은찬 on 10/29/25.
//

import SwiftUI

struct CheckListHeaderView: View {
    @Binding var isEditing: Bool
    var hasItems: Bool
    var toggleEditing: () -> Void

    var body: some View {
        HStack {

            Spacer()
                .frame(width: 150)

            Image("Header_AppIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 27)

            Spacer()

            if hasItems {
                Button(action: toggleEditing) {
                    Text(isEditing ? "완료" : "삭제")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.customBlack)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.bottom, 30)
        .background(Color.white)
    }
}
