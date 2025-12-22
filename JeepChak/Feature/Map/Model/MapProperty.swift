//
//  MapProperty.swift
//  JeepChak
//
//  Created by 김은찬 on 12/22/25.
//

import Foundation
import SwiftUI

struct MapProperty: Identifiable {
    let id: Int
    let name: String
    let address: String
    let propertyType: String
    let floor: Int
    let builtYear: Int
    let area: Int
    let marketPrice: Int
    let leaseType: String
    let deposit: Int
    let monthlyRent: Int?
    let memo: String
    let lat: Double
    let lng: Double
    
    var displayPropertyType: String {
        switch propertyType {
        case "APARTMENT": return "아파트"
        case "VILLA": return "빌라"
        case "OFFICETEL": return "오피스텔"
        case "ONE_ROOM": return "원룸"
        default: return "기타"
        }
    }
    
    var displayLeaseType: String {
        switch leaseType {
        case "JEONSE": return "전세"
        case "MONTHLY_RENT": return "월세"
        default: return "기타"
        }
    }
    
    var displayPrice: String {
        if leaseType == "JEONSE" {
            return "전세 \(formatNumber(deposit))만원"
        } else {
            if let monthlyRent = monthlyRent {
                return "월세 \(formatNumber(deposit))/\(formatNumber(monthlyRent))만원"
            } else {
                return "월세 \(formatNumber(deposit))만원"
            }
        }
    }
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

