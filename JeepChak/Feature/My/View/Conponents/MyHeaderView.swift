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

            Spacer()
                .frame(width: 158)

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
#Preview {
    MyHeaderView(toggleSetting: {})
}
