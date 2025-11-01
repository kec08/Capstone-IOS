//
//  RecentProperty.swift
//  JeepChak
//
//  Created by 김은찬 on 10/31/25.
//

import Foundation

struct RecentProperty: Identifiable, Hashable {
    let id = UUID()
    let type: String
    let area: String
    let imageName: String
    let location: String
    let price: String
}
