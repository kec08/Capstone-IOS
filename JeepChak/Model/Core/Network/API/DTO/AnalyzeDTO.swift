//
//  AnalyzeDTO.swift
//  JeepChak
//
//  Created by 김은찬 on 12/3/25.
//

import Foundation

// 매물분석 Request
struct AnalyzeRequestDTO: Codable {
    let propertyId: Int
    let marketPrice: Int
    let deposit: Int
    let monthlyRent: Int
}

// 대처방안 Request
struct RiskSolutionRequestDTO: Codable {
    let propertyId: Int
    let marketPrice: Int
    let deposit: Int
    let monthlyRent: Int
}

// Response
struct AnalyzeResponseDTO: Codable {
    let totalRisk: Int
    let details: [AnalyzeDetail]
    let comment: String
}

struct AnalyzeDetail: Codable {
    let original: String
    let analysis: String
}

// Get Response
struct AnalyzeDetailResponseDTO: Codable {
    let totalRisk: Int
    let details: [AnalyzeDetailItem]
    let comment: String
}

struct AnalyzeDetailItem: Codable {
    let original: String
    let analysisText: String
}
