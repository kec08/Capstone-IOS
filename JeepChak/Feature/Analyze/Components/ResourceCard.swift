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
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.customBlack)
                    .padding(.bottom, 4)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.customDarkGray)
            }
            
            Spacer()
            
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color(white: 0.97))
        .cornerRadius(12)
    }
}
