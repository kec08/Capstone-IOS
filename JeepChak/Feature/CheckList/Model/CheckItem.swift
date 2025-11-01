//
//  CheckItem.swift
//  JeepChak
//
//  Created by 김은찬 on 10/29/25.
//

import Foundation
import UIKit

struct CheckItem: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let imageName: String?
    var image: UIImage?
}
