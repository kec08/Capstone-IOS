//
//  CheckListItem.swift
//  JeepChak
//
//  Created by 김은찬 on 10/28/25.
//

import SwiftUI

enum LeaseType: String, Codable, CaseIterable {
    case monthly = "MONTHLY_RENT"
    case jeonse  = "JEONSE"

    var title: String {
        switch self {
        case .monthly: return "월세"
        case .jeonse:  return "전세"
        }
    }
}

enum PropertyType: String, Codable, CaseIterable, Identifiable {
    case APARTMENT
    case VILLA
    case OFFICETEL
    case ONE_ROOM
    case OTHER

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .APARTMENT: return "아파트"
        case .VILLA: return "빌라"
        case .OFFICETEL: return "오피스텔"
        case .ONE_ROOM: return "원룸"
        case .OTHER: return "기타"
        }
    }
}

struct AddCheckListItem: Identifiable {
    var id = UUID()
    var image: UIImage?

    var name: String
    var address: String
    var propertyType: PropertyType
    var floor: Int
    var area: Int
    var builtYear: Int

    var marketPrice: Int
    var leaseType: LeaseType
    var deposit: Int
    var monthlyRent: Int

    var memo: String
    var date: String

    var displayPrice: String {
        switch leaseType {
        case .monthly:
            return "월세 \(deposit)/\(monthlyRent)"
        case .jeonse:
            return "전세 \(deposit)"
        }
    }
}


