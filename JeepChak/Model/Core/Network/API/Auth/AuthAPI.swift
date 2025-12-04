//
//  AuthAPI.swift
//  Qiri
//
//  Created by 김은찬 on 5/25/25.
//

import Foundation
import Moya
internal import Alamofire

enum AuthAPI {
    case login(email: String, password: String)
    case signup(email: String, password: String, firstName: String, lastName: String)
    case refresh
}

extension AuthAPI: TargetType {

    var baseURL: URL {
        return URL(string: "http://zipchak-backend.kro.kr:8080")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/auth/login"
        case .signup:
            return "/api/auth/signup"
        case .refresh:
            return "/api/auth/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .signup:
            return .post
        case .refresh:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .login(email, password):
            let params: [String: Any] = [
                "email": email,
                "password": password
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case let .signup(email, password, firstName, lastName):
            let params: [String: Any] = [
                "email": email,
                "password": password,
                "firstName" : firstName,
                "lastName" : lastName
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .refresh:
            // 토큰 넣기
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
            switch self {
            case .login, .signup:
                return ["Content-Type": "application/json"]

            case .refresh:
                var headers: [String: String] = [
                    "Content-Type": "application/json"
                ]
                if let refresh = TokenStorage.refreshToken {
                    headers["Authorization"] = "Bearer \(refresh)"
                }
                return headers
            }
        }
}
