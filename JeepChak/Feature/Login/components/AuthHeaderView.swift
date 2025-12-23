//
//  AuthHeaderView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/9/25.
//

import SwiftUI

struct AuthHeaderView: View {
    var onBackTapped: () -> Void

    var body: some View {
        HStack {
            Spacer()
                .frame(width: 175)

            Image("Header_AppIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 27)

            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color.white)
    }
}


struct AuthHeaderView_Previews: PreviewProvider {
    static var previews: some View {
            LoginView()
    }
}
