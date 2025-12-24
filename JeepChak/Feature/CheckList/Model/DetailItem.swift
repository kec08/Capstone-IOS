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
    /// 서버에서 내려온 체크리스트 itemId (수정/업데이트 시 사용)
    var serverItemId: Int? = nil
}
