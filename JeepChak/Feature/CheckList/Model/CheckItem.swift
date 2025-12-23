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
    var detailItems: [DetailItem] = []
    let propertyId: Int? // 매물 ID 추가
    /// 체크리스트 저장 완료 여부 (저장 후 FinalView에서 확인 버튼 숨김에 사용)
    var isSaved: Bool = false
    /// 저장된 체크리스트 ID (있으면 서버 저장된 상태)
    var checklistId: Int? = nil
}
