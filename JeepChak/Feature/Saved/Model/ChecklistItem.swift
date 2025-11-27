//
//  ChecklistItem.swift
//  JeepChak
//
//  Created by 김은찬 on 11/27/25.
//

import Foundation

struct ChecklistItem: Identifiable {
    let id = UUID()
    let text: String
    var checked: Bool
}

