//
//  RootView.swift
//  JeepChak
//
//  Created by 김은찬 on 10/18/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var appState = AppState()
    @State private var showSplash = true

    init() {
        UITabBar.appearance().tintColor = UIColor(Color.customBlue)
    }

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                if appState.isLoggedIn {
                    MainTabView()
                        .environmentObject(appState)
                } else {
                    LoginView()
                        .environmentObject(appState)
                }
            }
        }
        .onAppear {
            appState.restoreLoginState()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 0.3)) {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    RootView()
}

