//  AuthService.swift
//  Eodigo
//
//  Created by 김은찬 on 12/03/25.
//

import Foundation
import Moya

enum AuthError: Error {
    case noRefreshToken
}

final class AuthService {
    static let shared = AuthService()
    private let provider = MoyaProvider<AuthAPI>()
    
    private init() {}
    
    // 로그인
    func login(email: String, password: String) async throws -> LoginResponse {
        let result = await provider.requestAsync(.login(email: email, password: password))
        switch result {
        case .success(let response):
            let decoded = try JSONDecoder().decode(LoginResponse.self, from: response.data)
            
            // 토큰 저장
            TokenStorage.accessToken = decoded.accessToken
            TokenStorage.refreshToken = decoded.refreshToken
            
            return decoded

        case .failure(let error):
            throw error
        }
    }
    
    // 회원가입
    func signup(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) async throws -> SignUpResponse {
        let result = await provider.requestAsync(
            .signup(email: email, password: password, firstName: firstName, lastName: lastName)
        )
        switch result {
        case .success(let response):
            let decoded = try JSONDecoder().decode(SignUpResponse.self, from: response.data)
            return decoded
        case .failure(let error):
            throw error
        }
    }

    // 토큰 재발급
    func refreshTokens() async throws -> LoginResponse {
        // 로컬 refreshToken 체크
        guard let refresh = TokenStorage.refreshToken, !refresh.isEmpty else {
            throw AuthError.noRefreshToken
        }

        // refresh 토큰을 넣어서 api 호출
        let result = await provider.requestAsync(.refresh(refreshToken: refresh))
        
        switch result {
        case .success(let response):
            let decoded = try JSONDecoder().decode(LoginResponse.self, from: response.data)
            
            // 새 토큰 저장
            TokenStorage.accessToken = decoded.accessToken
            TokenStorage.refreshToken = decoded.refreshToken
            
            print("토큰 리프레시 완료")
            return decoded

        case .failure(let error):
            TokenStorage.clear()
            throw error
        }
    }
}
