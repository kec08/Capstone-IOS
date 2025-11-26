//
//  PropertyUploadCard.swift
//  JeepChak
//
//  Created by 김은찬 on 11/26/25.
//

import SwiftUI

struct PropertyUploadCard: View {
    let selectedProperty: SavedProperty?
    @Binding var showingSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(spacing: 16) {
                if let property = selectedProperty {
                    SavedPropertyCard(property: property)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                } else {
                    Image("Analyz_home")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 128, height: 128)
                        .padding(.top, 5)
                        .padding(.bottom, -10)
                }
                
                Text("관심매물에서 간편하게 매물 업로드!")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.customBlack)
                    .padding(.bottom, 10)
                
                Button {
                    showingSheet = true
                } label: {
                    Text("매물 업로드 하기")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 26)
            }
            .frame(maxWidth: 350)
            .background(Color.white)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        }
    }
}

#Preview {
    PropertyUploadCard(selectedProperty: nil, showingSheet: .constant(false))
}
