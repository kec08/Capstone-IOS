//
//  LoginResponse.swift
//  Qiri
//
//  Created by 김은찬 on 5/25/25.
//
import Foundation

// 로그인 Request
struct LoginRequest: Codable {
    let email: String
    let password: String
}

// 로그인 Response
struct LoginResponse: Codable {
    let refreshToken: String
    let accessToken: String
}


// 회원가입 Request
struct SignUpRequest: Codable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let phone: String
}

// 회원가입 Response
struct SignUpResponse: Codable {
    let message: String
}
