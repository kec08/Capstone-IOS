//
//  LoginView.swift
//  Eodigo
//
//  Created by 김은찬 on 9/8/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                AuthHeaderView(onBackTapped: {
                    dismiss()
                })
                .padding(.bottom, 20)
                
                VStack(spacing: 32) {
                    titleSection

                    // Apple 로그인
                    AppleSignInStyledButton {
                        viewModel.signInWithApple()
                    }
                    .padding(.horizontal, 8)

                    Divider()
                        .padding(.horizontal, 40)

                    loginFormSection
                    autoLoginToggle
                    loginButton
                    signUpLink
                }
                .padding(.horizontal, 32)
                .padding(.top, 20)

                Spacer()
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarHidden(true)
            .alert("로그인 실패",
                   isPresented: $viewModel.showErrorAlert) {
                Button("확인", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }

    // 타이틀
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("로그인")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.customBlack)
                .padding(.bottom, 7)

            Text("간편하게 애플계정으로 로그인하여\n빠르게 서비스를 이용해보세요.")
                .font(.system(size: 14))
                .foregroundColor(.customDarkGray)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - 로그인
    private var loginFormSection: some View {
        VStack(spacing: 24) {
            Text("회원 로그인")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color.customBlack)

            VStack(spacing: 20) {
                CustomTextField(
                    placeholder: "이메일",
                    text: $viewModel.userId
                )

                CustomSecureField(
                    placeholder: "비밀번호",
                    text: $viewModel.password,
                    isSecure: $viewModel.isPasswordSecure
                )
            }
            .foregroundColor(Color.customBlack)
        }
    }

    // MARK: - 자동 로그인
    private var autoLoginToggle: some View {
        Button(action: {
            viewModel.autoLogin.toggle()
        }) {
            HStack(spacing: 8) {
                Image(systemName: viewModel.autoLogin ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(viewModel.autoLogin ? .cyan : .gray)

                Text("자동로그인")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - 로그인 버튼
    private var loginButton: some View {
        Button(action: {
            viewModel.login {
                appState.isLoggedIn = true
            }
        }) {
            Text("로그인")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(viewModel.isLoginEnabled ? .customWhite : .customBlack)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isLoginEnabled ? Color(UIColor.customBlue) : Color(UIColor.customGray100))
                .cornerRadius(10)
        }
        .disabled(!viewModel.isLoginEnabled)
    }

    // MARK: - 회원가입
    private var signUpLink: some View {
        NavigationLink(destination: SignUpView()) {
            Text("회원가입")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.customBlue)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(AppState())
    }
}
