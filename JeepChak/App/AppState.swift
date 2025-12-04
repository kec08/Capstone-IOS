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
    
    /// UserDefaults에서 로그인 상태를 복원
    func restoreLoginState() {
        let hasToken = (UserDefaults.standard.string(forKey: "accessToken") ?? "").isEmpty == false
        let autoLogin = UserDefaults.standard.bool(forKey: "autoLogin")
        
        // 자동로그인 ON + accessToken 상태 판단
        isLoggedIn = hasToken && autoLogin
    }
    
    /// 로그인 성공 시 호출
    func setLoggedIn() {
        isLoggedIn = true
    }
    
    func logout() {
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "autoLogin")
        UserDefaults.standard.removeObject(forKey: "savedUserId")
    }
}

