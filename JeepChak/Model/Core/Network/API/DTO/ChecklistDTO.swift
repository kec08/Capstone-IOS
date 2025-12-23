//
//  ChecklistRequest.swift
//  JeepChak
//
//  Created by 김은찬 on 11/15/25.
//

import Foundation

// MARK: - Request Models
struct ChecklistGenerateRequest: Codable {
    let propertyId: Int
}

struct ChecklistItemRequest: Codable {
    let content: String
    let severity: String
}

// 체크리스트 저장 요청
struct ChecklistSaveRequest: Codable {
    let propertyId: Int
    let items: [ChecklistSaveItem]
}

struct ChecklistSaveItem: Codable {
    let content: String
    /// NONE | NORMAL | WARNING | DANGER
    let severity: String
    let memo: String
}

// 체크리스트 수정 요청
struct ChecklistUpdateRequest: Codable {
    let itemId: Int?
    let memo: String?
    let severity: String?
}

struct GenerateChecklistRequest: Codable {
    let propertyId: Int
}

// MARK: - Response
struct ChecklistResponse: Codable {
    let checklistId: Int
    let propertyId: Int
    let itemCount: Int
    let createdAt: String
}

// 체크리스트 목록 조회 응답
struct ChecklistListResponse: Codable {
    let checklistId: Int
    let propertyId: Int
    let createdAt: String
    let itemCount: Int
}

struct GeneratedChecklistResponse: Codable {
    let contents: [String]?
    
    // 기존 content 필드와의 호환성을 위한 계산 속성
    var content: String? {
        return contents?.first
    }
    
    // 이니셜라이저 추가
    init(contents: [String]?) {
        self.contents = contents
    }
}

struct ChecklistDetailResponse: Codable {
    let checklistId: Int
    let propertyId: Int
    let items: [ChecklistItemDetail]
}

struct ChecklistItemDetail: Codable {
    let itemId: Int
    let content: String
    let severity: Int  // 0: none, 1: normal, 2: warning, 3: danger
    let memo: String?
}

// 체크리스트 수정 응답
struct ChecklistUpdateResponse: Codable {
    let checklistId: Int
    let propertyId: Int
    let updatedItemCount: Int
    let updatedAt: String
}
