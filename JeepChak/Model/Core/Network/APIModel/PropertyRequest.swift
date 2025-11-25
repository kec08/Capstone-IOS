//
//  PropertyRequest.swift
//  JeepChak
//
//  Created by 김은찬 on 11/18/25.
//

import Foundation

// MARK: - Request Models
struct PropertyRequest: Codable {
    let name: String
    let address: String
    let propertyType: String
    let floor: String
    let buildYear: String
    let area: String
    let availableDate: String
}

// MARK: - Response Models
struct PropertyListResponse: Codable {
    let propertyId: Int
    let name: String
    let address: String
    let createdAt: String
    // thumbnail은 multipart header로 별도 처리 필요
}

struct PropertyResponse: Codable {
    let propertyId: Int
    let name: String
    let address: String
    let propertyType: String
    let floor: Int
    let buildYear: Int
    let area: Int
    let availableDate: String
    let thumbnail: String?
    let createdAt: String
}

struct ApiResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: T
}
