//
//  MyViewModel.swift
//  Eodigo
//
//  Created by 김은찬 on 10/4/25.
//

import SwiftUI
import Combine

final class MyViewModel: ObservableObject {
    @Published var userInfo: UserInfo
    @Published var showSettings: Bool = false
    @Published var errorMessage: String? = nil

    private let authService = AuthService.shared

    init() {
        // 초기엔 빈 값으로 두고, 서버에서 내 정보 조회로 채움
        userInfo = UserInfo(name: "", email: "", phone: "", userId: "")
        fetchMe()
    }

    func openSettings() {
        showSettings = true
    }

    private func fetchMe() {
        // 로그인 토큰 없으면 조회하지 않음(목 데이터로 채우지 않음)
        guard let access = TokenStorage.accessToken, !access.isEmpty else { return }

        Task { @MainActor in
            do {
                let me = try await authService.getMe()
                // 표시 이름: 성 + 이름 (필요하면 포맷 바꿔도 됨)
                let displayName = "\(me.lastName)\(me.firstName)"
                self.userInfo.name = displayName
                self.userInfo.email = me.email
                self.userInfo.phone = "" // API 명세에 없음
                self.userInfo.userId = "\(me.id)"
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
