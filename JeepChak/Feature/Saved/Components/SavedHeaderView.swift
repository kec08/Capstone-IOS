//
//  SavedHeaderView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/15/25.
//

import SwiftUI

struct SavedHeaderView: View {
    let onBackTapped: () -> Void
    let onAddTapped: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onBackTapped) {
                Image(systemName: "chevron.left")
                    .font(SwiftUI.Font.system(size: 18, weight: .semibold))
                    .foregroundColor(SwiftUI.Color.customBlack)
                    .frame(width: 44, height: 44)
            }
            .contentShape(Rectangle())

            Spacer()
                .frame(width: 87 )

            Text("내 매물")
                .font(SwiftUI.Font.system(size: 18, weight: .bold))
                .foregroundColor(SwiftUI.Color.customBlack)

            Spacer()

            Button(action: onAddTapped) {
                Image(systemName: "plus")
                    .font(SwiftUI.Font.system(size: 18, weight: .semibold))
                    .foregroundColor(SwiftUI.Color.customBlack)
                    .frame(width: 44, height: 44)
            }
            .contentShape(Rectangle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(SwiftUI.Color.customWhite)
    }
}


struct SavedHeaderView_Previews: PreviewProvider {
    static var previews: some View {
            SavedHeaderView(
                onBackTapped: { },
                onAddTapped: { }
            )
    }
}
