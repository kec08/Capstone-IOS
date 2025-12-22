import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        restoreLoginState()
    }

    /// UserDefaults에서 로그인 상태 복원 및 토큰 만료면 자동 refresh
    func restoreLoginState() {
        let autoLogin = UserDefaults.standard.bool(forKey: "autoLogin")
        let access = UserDefaults.standard.string(forKey: "accessToken") ?? ""

        // 자동로그인 OFF
        guard autoLogin, !access.isEmpty else {
            isLoggedIn = false
            return
        }

        // accessToken 만료면 refresh 시도
        if JWT.isExpired(access) {
            Task { @MainActor in
                do {
                    _ = try await AuthService.shared.refreshTokens()
                    self.isLoggedIn = true
                } catch {
                    self.logout()
                }
            }
            return
        }

        // 만료 아니면 로그인 유지
        isLoggedIn = true
    }

    func setLoggedIn() {
        isLoggedIn = true
    }

    func logout() {
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "autoLogin")
        UserDefaults.standard.removeObject(forKey: "savedUserId")

        TokenStorage.clear()
    }
}

// MARK: - JWT 설정
enum JWT {
    static func isExpired(_ token: String) -> Bool {
        guard let exp = expirationDate(token) else { return true }
        return exp <= Date()
    }

    static func expirationDate(_ token: String) -> Date? {
        let parts = token.split(separator: ".")
        guard parts.count == 3 else { return nil }

        var base64 = String(parts[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        let pad = 4 - (base64.count % 4)
        if pad < 4 { base64 += String(repeating: "=", count: pad) }

        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let exp = json["exp"] as? TimeInterval
        else { return nil }

        return Date(timeIntervalSince1970: exp)
    }
}
