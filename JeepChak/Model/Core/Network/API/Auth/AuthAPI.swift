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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .signup:
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
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
