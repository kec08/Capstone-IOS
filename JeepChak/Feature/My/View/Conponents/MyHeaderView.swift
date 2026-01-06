//
//  MyHeaderView.swift.swift
//  JeepChak
//
//  Created by 김은찬 on 11/4/25.
//

import SwiftUI

struct MyHeaderView: View {
    
    var toggleSetting: () -> Void
    
    var body: some View {
        HStack {
            // 왼쪽 여백(타이틀 중앙 정렬을 위한 대칭)
            Color.clear
                .frame(width: 24, height: 24)

            Spacer()

            Text("마이")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.customBlack)

            Spacer()

            Button(action: toggleSetting) {
                Image("My_setting")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 12)
        .padding(.bottom, 30)
    }
}

struct MyHeaderView_Previews: PreviewProvider {
    static var previews: some View {
            MyHeaderView(toggleSetting: {})
    }
}
