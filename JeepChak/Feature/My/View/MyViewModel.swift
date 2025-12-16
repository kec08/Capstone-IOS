//
//  MyViewModel.swift
//  Eodigo
//
//  Created by 김은찬 on 10/4/25.
//

import SwiftUI
import Combine

final class MyViewModel: ObservableObject {
    private let appState: AppState
    @Published var userInfo: UserInfo
    @Published var showSettings: Bool = false

    init(appState: AppState) {
            self.appState = appState
            
            userInfo = UserInfo(
                name: "김은찬",
                email: "eunchan@example.com",
                phone: "010-1234-5678",
                userId: "kimeunchan"
            )
        }

    func openSettings() {
        showSettings = true
    }

    func logout() {
        appState.logout()
        print("로그아웃 실행")
    }
}
