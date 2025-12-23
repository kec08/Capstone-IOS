//
//  ResourceCard.swift
//  JeepChak
//
//  Created by 김은찬 on 11/27/25.
//

import SwiftUI

struct ResourceCard: View {
    let title: String
    let subtitle: String
    var iconSystemName: String = "square.and.arrow.up"
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(SwiftUI.Font.system(size: 14, weight: .semibold))
                    .foregroundColor(SwiftUI.Color.customBlack)

                Text(subtitle)
                    .font(SwiftUI.Font.system(size: 12))
                    .foregroundColor(SwiftUI.Color.customDarkGray)
                    .lineLimit(2)
            }

            Spacer(minLength: 8)

            Image(systemName: iconSystemName)
                .font(SwiftUI.Font.system(size: 16, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color(white: 0.97))
        .cornerRadius(12)
    }
}


struct ResourceCard_Previews: PreviewProvider {
    static var previews: some View {
            VStack(spacing: 12) {
                ResourceCard(title: "등기부등본", subtitle: "파일을 업로드해서 분석에 활용하세요")
                ResourceCard(title: "건축물대장", subtitle: "PDF 파일 1~2개 업로드", iconSystemName: "doc.fill")
            }
            .padding()
            .background(SwiftUI.Color.customWhite)
    }
}
