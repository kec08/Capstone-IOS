//
//  UserInfo.swift
//  JeepChak
//
//  Created by 김은찬 on 11/5/25.
//

import Foundation

struct UserInfo: Identifiable, Codable {
    let id = UUID()
    var name: String
    var email: String
    var phone: String
    var userId: String
    var wishCount: Int
    var analysisCount: Int
    var checklistCount: Int
}
