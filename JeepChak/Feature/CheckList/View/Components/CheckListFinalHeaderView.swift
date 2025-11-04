//
//  CheckListFinalHeaderView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/3/25.
//

import SwiftUI

struct CheckListFinalHeaderView: View {
    var onBackTapped: () -> Void
    var onEditTapped: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBackTapped) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(.customBlack)
            }
            
            Spacer()
            
            Text("체크리스트")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: onEditTapped) {
                Text("수정")
                    .font(.system(size: 16))
                    .foregroundColor(.customBlack)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.customWhite)
    }
}

#Preview("Final Header") {
    CheckListFinalHeaderView(onBackTapped: {}, onEditTapped: {})
}
