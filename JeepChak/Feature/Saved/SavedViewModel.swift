//
//  SavedViewModel.swift
//  JeepChak
//
//  Created by 김은찬 on 11/15/25.
//

import SwiftUI
import Foundation
import Combine

final class SavedViewModel: ObservableObject {
    @Published var properties: [SavedProperty] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let propertyService = PropertyService()
    private var cancellables = Set<AnyCancellable>()

    init() {
            fetchProperties()
        }

        // 프리뷰/테스트용 init
        init(mockProperties: [SavedProperty]) {
            self.properties = mockProperties
            self.isLoading = false
            self.errorMessage = nil
        }

    // 전체 매물 조회
    func fetchProperties() {
        isLoading = true
        errorMessage = nil

        propertyService.getProperties()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false

                switch completion {
                case .finished:
                    print("매물 목록 조회 완료")
                case .failure(let e):
                    self.errorMessage = e.localizedDescription
                    print("매물 목록 조회 실패:", e.localizedDescription)
                }
            } receiveValue: { [weak self] responses in
                guard let self = self else { return }
                self.properties = responses.map { SavedProperty.from($0) }
                print("조회된 매물 개수:", self.properties.count)
            }
            .store(in: &cancellables)
    }

    // 매물 생성 - AddCheckListView에서 호출
    func createProperty(
        from newItem: AddCheckListItem,
        onSuccess: @escaping (SavedProperty) -> Void
    ) {
        let request = PropertyRequest(
            name: newItem.title,
            address: newItem.address,
            propertyType: newItem.propertyType,
            floor: newItem.unit,
            buildYear: "",
            area: "",
            availableDate: newItem.date
        )

        propertyService.createProperty(request: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let e) = completion {
                    print("매물 생성 실패:", e.localizedDescription)
                }
            } receiveValue: { [weak self] res in
                guard let self = self else { return }

                let saved = SavedProperty(
                    id: res.propertyId,
                    propertyId: res.propertyId,
                    image: newItem.image,
                    type: newItem.propertyType,
                    name: newItem.title,
                    details: newItem.address,
                    description: newItem.memo,
                    price: newItem.unit,
                    createdAt: res.createdAt
                )

                self.properties.append(saved)
                onSuccess(saved)
            }
            .store(in: &cancellables)
    }
}
