//
//  SavedModel.swift
//  JeepChak
//
//  Created by 김은찬 on 11/15/25.
//

import SwiftUI

struct SavedProperty: Identifiable {
    let id: Int
    let propertyId: Int
    var image: UIImage?
    let type: String
    let name: String
    let details: String
    let description: String
    let price: String
    let createdAt: String?
}

extension SavedProperty {
    static func from(_ r: PropertyListResponse) -> SavedProperty {
        SavedProperty(
            id: r.propertyId,
            propertyId: r.propertyId,
            image: nil,
            type: "매물",
            name: r.name,
            details: r.address,
            description: "",
            price: "",
            createdAt: r.createdAt
        )
    }
}

