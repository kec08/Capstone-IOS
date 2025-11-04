//
//  ProfileSection.swift
//  JeepChak
//
//  Created by 김은찬 on 11/5/25.
//

import SwiftUI

struct ProfileSection: View {
    let userInfo: UserInfo

    var body: some View {
        HStack(spacing: 16) {
            Image("My_profile")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text(userInfo.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)

                Text(userInfo.email)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()
        }
    }
}
