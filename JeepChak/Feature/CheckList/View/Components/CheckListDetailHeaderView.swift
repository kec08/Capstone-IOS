//
//  CheckListDetailHeaderView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/3/25.
//

import SwiftUI

struct CheckListDetailHeaderView: View {
    var onBackTapped: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBackTapped) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(.customBlack)
            }
            
            Spacer()
            
            Text("체크리스트")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.customBlack)
            
            Spacer()
            
            Color.clear.frame(width: 24)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
    }
}

#Preview("Detail Header") {
    CheckListDetailHeaderView(onBackTapped: {})
}
