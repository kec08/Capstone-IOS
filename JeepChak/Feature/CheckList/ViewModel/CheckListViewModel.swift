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
    
    private let checklistService = ChecklistService()
    private var cancellables = Set<AnyCancellable>()

    // 추가
    func addItem(title: String, date: String, image: UIImage? = nil) {
        let newItem = CheckItem(title: title, date: date, imageName: nil, image: image)
        withAnimation {
            checkItems.append(newItem)
        }
    }

    // 삭제
    func deleteItem(_ item: CheckItem) {
        // TODO: item에 checklistId가 있으면 서버 삭제 API 호출
        // 현재는 로컬에서만 삭제
        withAnimation {
            checkItems.removeAll { $0.id == item.id }
        }
    }
    
    // 서버에서 체크리스트 삭제
    func deleteChecklistFromServer(checklistId: Int, item: CheckItem) {
        checklistService.deleteChecklist(id: checklistId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("체크리스트 삭제 실패: \(error.localizedDescription)")
                }
            } receiveValue: { message in
                print("체크리스트 삭제 성공: \(message)")
                // 로컬에서도 삭제
                withAnimation {
                    self.checkItems.removeAll { $0.id == item.id }
                }
            }
            .store(in: &cancellables)
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
