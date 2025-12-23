//
//  PropertyUploadHeaderView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/26/25.
//

import SwiftUI

struct PropertyUploadHeaderView: View {
    let title: String
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.customBlack)
                }
                
                Spacer()
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.customBlack)
                
                Spacer()
                
                Spacer()
                    .frame(width: 24)
            }
            .padding(.horizontal, 20)
            .padding(.top, 35)
            
            HStack {
                Text("매물 업로드")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.customBlack)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
        .background(Color.white)
    }
}


struct PropertyUploadHeaderView_Previews: PreviewProvider {
    static var previews: some View {
            PropertyUploadHeaderView(title: "매물 업로드", onBack: {})
    }
}
