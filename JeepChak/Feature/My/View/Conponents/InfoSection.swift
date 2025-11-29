//
//  InfoSection.swift
//  JeepChak
//
//  Created by 김은찬 on 11/5/25.
//

import SwiftUI

struct InfoSection: View {
    let userInfo: UserInfo

    var body: some View {
        VStack(spacing: 0) {
            Text("내 정보")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.customBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 15)

            InfoRow(icon: "My_user", title: "이름", value: userInfo.name)
            InfoRow(icon: "My_id", title: "아이디", value: userInfo.userId)
            InfoRow(icon: "My_phone", title: "전화번호", value: userInfo.phone)
            InfoRow(icon: "My_email", title: "이메일", value: userInfo.email)
        }
        .padding(20)
        .background(Color.customWhite)
        .cornerRadius(12)
    }
}
