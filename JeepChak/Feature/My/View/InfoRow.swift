//
//  InfoRow.swift
//  JeepChak
//
//  Created by 김은찬 on 11/5/25.
//

import SwiftUI

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(icon)
                .font(.system(size: 20))
                .foregroundColor(.black)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.black)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    VStack {
        InfoRow(icon: "My_user", title: "이름", value: "김은찬")
        InfoRow(icon: "My_email", title: "이메일", value: "kec@naver.com")
    }
    .padding()
}

