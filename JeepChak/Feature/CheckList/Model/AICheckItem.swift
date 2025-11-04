//
//  AICheckItem.swift
//  JeepChak
//
//  Created by 김은찬 on 11/3/25.
//

import Foundation

struct AICheckItem: Identifiable {
    let id = UUID()
    var name: String
    var isChecked: Bool = false
}
