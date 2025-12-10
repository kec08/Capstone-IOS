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
    let floor: Int
    let builtYear: Int
    let area: Double
    let availableDate: String
}

// MARK: - Response Models
struct PropertyListResponse: Codable {
    let propertyId: Int
    let name: String
    let address: String
    let createdAt: String?
}

struct PropertyResponse: Codable {
    let propertyId: Int
    let name: String
    let address: String
    let propertyType: String
    let floor: Int
    let builtYear: Int
    let area: Int
    let availableDate: String
    let thumbnail: String?
    let createdAt: String
}

struct ApiResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: T?
}
