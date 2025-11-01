//
//  CheckListEmptyView.swift
//  JeepChak
//
//  Created by 김은찬 on 10/29/25.
//

import SwiftUI

struct CheckListEmptyView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("체크리스트가 없습니다")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color.customBlack)
            
            Text("+ 버튼을 눌러\n체크리스트를 추가해보세요!")
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .foregroundColor(.customDarkGray)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
