//
//  SavedHeaderView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/15/25.
//

import SwiftUI

struct SavedHeaderView: View {
    var onBackTapped: () -> Void
    var onAddTapped: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBackTapped) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(.customBlack)
            }
            
            Spacer()
            
            Text("관심매물")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
                .frame(width: 120)
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .background(Color.customWhite)
    }
}

#Preview {
    SavedHeaderView(onBackTapped: {}, onAddTapped: {})
}
