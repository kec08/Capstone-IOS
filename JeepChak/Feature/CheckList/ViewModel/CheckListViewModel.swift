//
//  CheckListViewModel.swift
//  Eodigo
//
//  Created by 김은찬 on 10/4/25.
//

import SwiftUI
import Combine

final class CheckListViewModel: ObservableObject {
    @Published var checkItems: [CheckItem] = [
        CheckItem(title: "봉양면 ㅇㅇ주택", date: "2025-09-16", imageName: "CheckListHouse1", image: nil),
        CheckItem(title: "봉양면 ㅇㅇ주택", date: "2025-09-16", imageName: "CheckListHouse2", image: nil),
        CheckItem(title: "봉양면 ㅇㅇ주택", date: "2025-09-16", imageName: "CheckListHouse3", image: nil)
    ]
    
    @Published var isEditing = false
    @Published var showDeleteAlert = false
    @Published var itemToDelete: CheckItem?
    @Published var showAddSheet = false

    // 추가
    func addItem(title: String, date: String, image: UIImage? = nil) {
        let newItem = CheckItem(title: title, date: date, imageName: nil, image: image)
        withAnimation {
            checkItems.append(newItem)
        }
    }

    // 삭제
    func deleteItem(_ item: CheckItem) {
        withAnimation {
            checkItems.removeAll { $0.id == item.id }
        }
    }

    // 편집 모드
    func toggleEditing() {
        withAnimation {
            isEditing.toggle()
        }
    }

    // 삭제 묻기
    func confirmDelete(_ item: CheckItem) {
        itemToDelete = item
        showDeleteAlert = true
    }
}
