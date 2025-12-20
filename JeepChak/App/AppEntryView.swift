//
//  AppEntryView.swift
//  JeepChak
//
//  Created by 김은찬 on 12/18/25.
//

import SwiftUI

struct AppEntryView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        Group {
            switch appState.route {
            case .splash:
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            appState.goLogin()
                        }
                    }

            case .login:
                LoginView(onLoginSuccess: {
                    appState.goMain()
                })

            case .main:
                RootView()
            }
        }
        .environmentObject(appState)
    }
}
