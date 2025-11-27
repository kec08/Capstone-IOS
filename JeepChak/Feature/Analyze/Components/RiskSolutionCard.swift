//
//  RiskSolutionCard.swift
//  JeepChak
//
//  Created by 김은찬 on 11/27/25.
//

import SwiftUI

struct RiskSolutionCard: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.red)
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(items, id: \.self) { text in
                    HStack(alignment: .top, spacing: 6) {
                        Text("•")
                            .foregroundColor(.customBlack)
                        Text(text)
                            .font(.system(size: 13))
                            .foregroundColor(.customBlack)
                    }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 1.0, green: 0.95, blue: 0.95))
        .cornerRadius(16)
    }
}
