//
//  SignUpView.swift
//  Eodigo
//
//  Created by 김은찬 on 11/9/25.
//

import SwiftUI
import UIKit

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AuthHeaderView(onBackTapped: {
                    dismiss()
                })
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                titleSection
                    .padding(.horizontal, 32)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        signUpFormSection
                        
                        signUpButton
                        
                        loginLink
                    }
                    // iPad 등 큰 화면 대응
                    .frame(maxWidth: 420)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.customWhite.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .alert(viewModel.alertTitle,
               isPresented: $viewModel.showAlert) {
            Button("확인") {
                if viewModel.alertTitle == "회원가입 성공" {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

// MARK: - UI
extension SignUpView {
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("회원가입")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.customBlack)
                .padding(.bottom, 7)

            Text("빠르게 로그인하여 서비스를 이용해보세요.")
                .font(.system(size: 14))
                .foregroundColor(.customDarkGray)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var signUpFormSection: some View {
        VStack(spacing: 16) {
            CustomTextField(placeholder: "성", text: $viewModel.firstName)
            CustomTextField(placeholder: "이름", text: $viewModel.lastName)
            CustomTextField(placeholder: "이메일", text: $viewModel.email)
            CustomSecureField(placeholder: "비밀번호", text: $viewModel.password, isSecure: $viewModel.isPasswordSecure)
                CustomSecureField(placeholder: "비밀번호 확인", text: $viewModel.passwordCheck, isSecure: $viewModel.isConfirmSecure)
            }
        .foregroundColor(Color.customBlack)
        }
    
    private var signUpButton: some View {
        Button(action: viewModel.signUp) {
            Text("회원가입")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(viewModel.isSignUpEnabled ? .customWhite : .customBlack)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isSignUpEnabled ? Color(UIColor.customBlue) : Color(UIColor.customGray100))
                .cornerRadius(12)
        }
        .disabled(!viewModel.isSignUpEnabled)
        .padding(.top, 10)
    }
    
    private var loginLink: some View {
        NavigationLink(destination: LoginView()) {
            Text("로그인")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.customBlue)
                .frame(maxWidth: .infinity)
        }
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
            SignUpView()
    }
}
