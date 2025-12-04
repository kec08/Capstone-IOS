import SwiftUI
import Combine

final class SignUpViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordCheck: String = ""

    @Published var isPasswordSecure: Bool = true
    @Published var isConfirmSecure: Bool = true
    
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""

    var isSignUpEnabled: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password == passwordCheck
    }

    private let authService = AuthService.shared

    func signInWithApple() {
        print("Apple 로그인 시도")
    }

    @MainActor
    func signUp() {
        guard isSignUpEnabled else { return }

        Task {
            do {
                let res = try await authService.signup(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: password
                )

                print("회원가입 성공:", res)

                alertTitle = "회원가입 성공"
                alertMessage = res.message.isEmpty
                    ? "회원가입이 완료되었습니다. 로그인 화면으로 이동합니다."
                    : res.message
                showAlert = true

            } catch {
                print("회원가입 오류:", error.localizedDescription)

                alertTitle = "회원가입 실패"
                alertMessage = "회원가입 중 오류가 발생했습니다.\n\(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}
