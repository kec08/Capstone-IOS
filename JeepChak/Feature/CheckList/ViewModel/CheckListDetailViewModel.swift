//
//  CheckListDetailViewModel.swift
//  JeepChak
//
//  Created by 김은찬 on 11/2/25.
//

import SwiftUI
import Combine

final class CheckListDetailViewModel: ObservableObject {
    @Published var items: [DetailItem] = [
        .init(name: "화장실 곰팡이 확인하기"),
        .init(name: "벽과 바닥 상태 확인하기"),
        .init(name: "창문 틈새 확인하기"),
        .init(name: "수압 확인하기"),
        .init(name: "보일러 작동 확인하기")
    ]
    
    @Published var newItemName: String = ""
    @Published var showAddItemSheet: Bool = false
    
    func addNewItem() {
        guard !newItemName.isEmpty else { return }
        items.append(DetailItem(name: newItemName))
        newItemName = ""
        showAddItemSheet = false
    }
    
    func dismissAddSheet() {
        showAddItemSheet = false
        newItemName = ""
    }
}
