import SwiftUI
import Combine

final class LoginViewModel: ObservableObject {
    @Published var userId: String = ""
    @Published var password: String = ""
    @Published var isPasswordSecure: Bool = true
    @Published var autoLogin: Bool = false

    @Published var isLoginEnabled: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""

    private let authService = AuthService.shared

    init() {
        $userId
            .combineLatest($password)
            .map { !$0.isEmpty && !$1.isEmpty }
            .assign(to: &$isLoginEnabled)
    }

    func signInWithApple() {
        print("Apple 로그인 시도")
    }

    // MARK: - 로그인 API
    @MainActor
    func login(onSuccess: @escaping () -> Void) {
        guard isLoginEnabled else { return }

        Task {
            do {
                let response = try await authService.login(email: userId, password: password)

                print("로그인 성공:", response.accessToken)

                // 토큰 저장
                UserDefaults.standard.set(response.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(response.refreshToken, forKey: "refreshToken")

                // 자동 로그인 선택 시
                if autoLogin {
                    UserDefaults.standard.set(true, forKey: "autoLogin")
                    UserDefaults.standard.set(userId, forKey: "savedUserId")
                }

                isLoggedIn = true
                
                onSuccess()

            } catch {
                showErrorAlert = true
                errorMessage = "로그인에 실패했습니다. 다시 시도해주세요."
                print("로그인 오류:", error.localizedDescription)
            }
        }
    }

    func loadAutoLogin() {
        let savedAutoLogin = UserDefaults.standard.bool(forKey: "autoLogin")
        if savedAutoLogin {
            userId = UserDefaults.standard.string(forKey: "savedUserId") ?? ""
            autoLogin = true
        }
    }

    func logout() {
        isLoggedIn = false
        autoLogin = false
        UserDefaults.standard.removeObject(forKey: "autoLogin")
        UserDefaults.standard.removeObject(forKey: "savedUserId")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
    }
}
