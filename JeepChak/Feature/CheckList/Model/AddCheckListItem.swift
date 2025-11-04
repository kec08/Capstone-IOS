//
//  CheckListItem.swift
//  JeepChak
//
//  Created by 김은찬 on 10/28/25.
//

import SwiftUI

struct AddCheckListItem: Identifiable {
    var id = UUID()
    var image: UIImage?
    var title: String
    var address: String
    var propertyType: String
    var unit: String
    var memo: String
    var date: String
}

