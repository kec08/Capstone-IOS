//
//  ChecklistRequest.swift
//  JeepChak
//
//  Created by 김은찬 on 11/15/25.
//

import Foundation

// MARK: - Request Models
struct ChecklistRequest: Codable {
    let propertyId: Int
    let items: [ChecklistItemRequest]
}

struct ChecklistItemRequest: Codable {
    let content: String
    let severity: String   // "NONE", "NORMAL", "WARNING", "DANGER"
}

struct GenerateChecklistRequest: Codable {
    let propertyId: Int
}

// MARK: - Response Models
struct ChecklistResponse: Codable {
    let checklistId: Int
    let propertyId: Int
    let itemCount: Int
    let createdAt: String
}

struct GeneratedChecklistResponse: Codable {
    let content: String
}

struct ChecklistDetailResponse: Codable {
    let checklistId: Int
    let propertyId: Int
    let items: [ChecklistItemDetail]
}

struct ChecklistItemDetail: Codable {
    let itemId: Int
    let content: String
    let severity: Int
    let memo: String?
}
