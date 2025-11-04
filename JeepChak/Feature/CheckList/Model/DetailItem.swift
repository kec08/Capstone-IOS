//
//  DetailItem.swift
//  JeepChak
//
//  Created by 김은찬 on 11/2/25.
//

import SwiftUI

struct DetailItem: Identifiable {
    let id = UUID()
    var name: String
    var status: String = "none"
    var memo: String = ""
}
