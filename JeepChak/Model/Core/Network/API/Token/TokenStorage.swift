//
//  TokenStorage.swift
//  JeepChak
//
//  Created by 김은찬 on 12/5/25.
//

import Foundation

enum TokenStorage {
    private static let accessKey = "accessToken"
    private static let refreshKey = "refreshToken"

    static var accessToken: String? {
        get { UserDefaults.standard.string(forKey: accessKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: accessKey) }
    }

    static var refreshToken: String? {
        get { UserDefaults.standard.string(forKey: refreshKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: refreshKey) }
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: accessKey)
        UserDefaults.standard.removeObject(forKey: refreshKey)
    }
}
