//  AuthService.swift
//  Eodigo
//
//  Created by 김은찬 on 12/03/25.
//

import Foundation
import Moya

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
    func signup(firstName: String, lastName: String, email: String, password: String) async throws -> SignUpResponse {
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

    func refreshTokens() async throws -> LoginResponse {
        let result = await provider.requestAsync(.refresh)
        switch result {
        case .success(let response):
            let decoded = try JSONDecoder().decode(LoginResponse.self, from: response.data)

            // 새 토큰으로 덮어쓰기
            TokenStorage.accessToken = decoded.accessToken
            TokenStorage.refreshToken = decoded.refreshToken

            print("토큰 리프레시 완료")
            return decoded

        case .failure(let error):
            // refresh 실패 시 토큰 날리고 로그아웃 처리
            TokenStorage.clear()
            throw error
        }
    }
}
