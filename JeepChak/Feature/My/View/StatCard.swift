//
//  StatCard.swift
//  JeepChak
//
//  Created by 김은찬 on 11/5/25.
//

import SwiftUI

struct StatCard: View {
    let icon: String
    let title: String
    let count: Int
    var imageWidth: CGFloat
    var imageHeight: CGFloat

    var body: some View {
        VStack(spacing: 10) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: imageWidth, height: imageHeight)
                .padding(.bottom, 4)
            
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                Text("\(count)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.customBlue)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(16)
    }
}

