//
//  CheckListViewModel.swift
//  Eodigo
//
//  Created by 김은찬 on 10/4/25.
//

import SwiftUI
import Combine
import UIKit

final class CheckListViewModel: ObservableObject {
    @Published var checkItems: [CheckItem] = []
    
    @Published var isEditing = false
    @Published var showDeleteAlert = false
    @Published var itemToDelete: CheckItem?
    @Published var showAddSheet = false
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var showLoadErrorAlert: Bool = false
    
    private let checklistService = ChecklistService()
    private let propertyService = PropertyService()
    private var cancellables = Set<AnyCancellable>()
    private var hasLoadedOnce = false

    init() {
        loadChecklistsIfNeeded()
    }

    func loadChecklistsIfNeeded() {
        guard !hasLoadedOnce else { return }
        hasLoadedOnce = true
        loadChecklists()
    }

    func refresh() {
        loadChecklists()
    }

    private func loadChecklists() {
        isLoading = true
        errorMessage = nil
        showLoadErrorAlert = false

        // 기존에 추가해둔(저장 전) 로컬 항목은 유지
        let localUnsaved = checkItems.filter { !$0.isSaved }

        let propertiesPublisher = propertyService.getProperties()
            .catch { err -> AnyPublisher<[PropertyListResponse], Error> in
                // 매물 매핑 실패해도 체크리스트 목록은 보여주기 위해 fallback
                print("매물 목록 조회 실패(체크리스트 매핑용): \(err.localizedDescription)")
                return Just([])
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        Publishers.Zip(checklistService.getChecklists(), propertiesPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let err) = completion {
                    self.errorMessage = err.localizedDescription
                    self.showLoadErrorAlert = true
                }
            } receiveValue: { [weak self] checklists, properties in
                guard let self else { return }

                let propById = Dictionary(uniqueKeysWithValues: properties.map { ($0.propertyId, $0) })

                let serverItems: [CheckItem] = checklists.map { cl in
                    let prop = propById[cl.propertyId]
                    let title = prop?.name ?? "매물 \(cl.propertyId)"
                    let date = self.formatDate(cl.createdAt)
                    let imageName = self.placeholderImageName(for: cl.propertyId)

                    return CheckItem(
                        title: title,
                        date: date,
                        imageName: imageName,
                        image: nil,
                        detailItems: [],
                        propertyId: cl.propertyId,
                        isSaved: true,
                        checklistId: cl.checklistId
                    )
                }

                self.checkItems = localUnsaved + serverItems
            }
            .store(in: &cancellables)
    }

    // 추가
    func addItem(title: String, date: String, image: UIImage? = nil, propertyId: Int? = nil) {
        let newItem = CheckItem(title: title, date: date, imageName: nil, image: image, propertyId: propertyId)
        withAnimation {
            checkItems.append(newItem)
        }
    }

    // 삭제
    func deleteItem(_ item: CheckItem) {
        if let checklistId = item.checklistId {
            deleteChecklistFromServer(checklistId: checklistId, item: item)
        } else {
            withAnimation {
                checkItems.removeAll { $0.id == item.id }
            }
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

    // 날짜 포맷팅 함수
    private func formatDate(_ dateString: String) -> String {
        if dateString.contains("T") {
            let components = dateString.components(separatedBy: "T")
            if let datePart = components.first { return datePart }
        }
        return dateString
    }

    private func placeholderImageName(for propertyId: Int) -> String? {
        // 에셋이 많다고 하셔서 property_1 ~ property_14를 우선 사용
        let pool = (1...14).map { "property_\($0)" }
        let candidate = pool[abs(propertyId) % pool.count]
        return candidate
    }
}
