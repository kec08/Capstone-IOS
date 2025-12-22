//
//  TourSpot.swift
//  Eodigo
//
//  Created by 김은찬 on 12/18/25.
//

import Foundation

struct TourSpot: Identifiable {
    let id: UUID
    let name: String
    let category: String?
    let reviewCount: Int?
    let address: String?
    let phone: String?
    let website: String?
    let description: String?
    let imageName: String?
    let priceText: String?
    let lat: Double
    let lng: Double
    
    init(
        id: UUID = UUID(),
        name: String,
        category: String? = nil,
        reviewCount: Int? = nil,
        address: String? = nil,
        phone: String? = nil,
        website: String? = nil,
        description: String? = nil,
        imageName: String? = nil,
        priceText: String? = nil,
        lat: Double,
        lng: Double
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.reviewCount = reviewCount
        self.address = address
        self.phone = phone
        self.website = website
        self.description = description
        self.imageName = imageName
        self.priceText = priceText
        self.lat = lat
        self.lng = lng
    }
}
