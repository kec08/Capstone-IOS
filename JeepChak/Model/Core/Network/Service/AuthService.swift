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
    
    // MARK: - 로그인
    func login(email: String, password: String) async throws -> LoginResponse {
        let result = await provider.requestAsync(.login(email: email, password: password))
        
        switch result {
        case .success(let response):
            print(String(data: response.data, encoding: .utf8) ?? "nil")
            return try JSONDecoder().decode(LoginResponse.self, from: response.data)
            
        case .failure(let error):
            throw error
        }
    }
    
    // MARK: - 회원가입
    func signup(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) async throws -> SignUpResponse {
        let result = await provider.requestAsync(
            .signup(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName
            )
        )
        
        switch result {
        case .success(let response):
            print(String(data: response.data, encoding: .utf8) ?? "nil")
            return try JSONDecoder().decode(SignUpResponse.self, from: response.data)
            
        case .failure(let error):
            throw error
        }
    }
}
