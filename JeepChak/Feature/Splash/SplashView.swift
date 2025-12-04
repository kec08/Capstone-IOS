//
//  SplashView.swift
//  JeepChak
//
//  Created by 김은찬 on 10/19/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.customWhite
                .ignoresSafeArea()

            VStack {
                Spacer()
                    .frame(height: 285)

                Image("Splash_img")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 231)

                Spacer()
                    .frame(height: 340)
            }
        }
    }
}

#Preview {
    SplashView()
}
