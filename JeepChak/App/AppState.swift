//
//  AppState.swift
//  JeepChak
//
//  Created by 김은찬 on 11/9/25.
//

import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        restoreLoginState()
    }

    func restoreLoginState() {
        let autoLogin = UserDefaults.standard.bool(forKey: "autoLogin")

        // 자동로그인 ON + 토큰이 유효해야만 true
        if autoLogin, TokenStorage.isAccessTokenValid() {
            isLoggedIn = true
        } else {
            // 만료시 로그아웃
            logout()
        }
    }

    func setLoggedIn() {
        isLoggedIn = true
    }

    func logout() {
        isLoggedIn = false
        TokenStorage.clear()
        UserDefaults.standard.removeObject(forKey: "autoLogin")
        UserDefaults.standard.removeObject(forKey: "savedUserId")
    }
}
