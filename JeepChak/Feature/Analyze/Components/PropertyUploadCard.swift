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
                    
                    Button {
                        showingSheet = true
                    } label: {
                        Text("매물 다시 선택하기")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.customBlue)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 16)
                } else {
                    Image("Analyz_home")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 128, height: 128)
                        .padding(.top, 5)
                        .padding(.bottom, -10)
                    
                    Button {
                        showingSheet = true
                    } label: {
                        Text("매물 업로드 하기")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.customBlue)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 26)
                }
            }
            .frame(maxWidth: 350)
            .background(Color.white)
            .cornerRadius(18)
            .shadow(color: Color.customBlack.opacity(0.06), radius: 12, x: 0, y: 4)
        }
    }
}


struct PropertyUploadCard_Previews: PreviewProvider {
    static var previews: some View {
            PropertyUploadCard(selectedProperty: nil, showingSheet: .constant(false))
    }
}
