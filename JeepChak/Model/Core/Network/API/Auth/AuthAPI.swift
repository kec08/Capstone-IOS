//
//  AuthAPI.swift
//  Qiri
//
//  Created by 김은찬 on 5/25/25.

import Foundation
import Moya

enum AuthAPI {
    case login(username: String, password: String)
}
