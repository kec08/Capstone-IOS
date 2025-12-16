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
    @Published var errorMessage: String? = nil

    private let propertyService = PropertyService()
    private var cancellables = Set<AnyCancellable>()

    init(mockProperties: [SavedProperty] = []) {
            self.properties = mockProperties
        }
    
    init() { fetchProperties() }

    // 전체 매물 조회
    func fetchProperties() {
        isLoading = true
        errorMessage = nil

        propertyService.getProperties()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let e) = completion {
                    self.errorMessage = e.localizedDescription
                    print("매물 목록 조회 실패:", e.localizedDescription)
                }
            } receiveValue: { [weak self] responses in
                guard let self else { return }
                self.properties = responses.map { SavedProperty.from($0) }
            }
            .store(in: &cancellables)
    }

    // MARK: - 매물 생성
    func createProperty(from newItem: AddCheckListItem, onSuccess: @escaping (String) -> Void) {

        // PropertyType -> 서버 코드(String)
        let propertyTypeCode = newItem.propertyType.rawValue

        // 전세면 monthlyRent는 0으로 강제
        let monthly = (newItem.leaseType == .jeonse) ? 0 : newItem.monthlyRent

        let request = PropertyRequest(
            name: newItem.name,
            address: newItem.address,
            propertyType: propertyTypeCode,
            floor: newItem.floor,
            builtYear: newItem.builtYear,
            area: newItem.area,
            marketPrice: newItem.marketPrice,
            leaseType: newItem.leaseType.rawValue,
            deposit: newItem.deposit,
            monthlyRent: monthly,
            memo: newItem.memo
        )

        propertyService.createProperty(request: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let e) = completion {
                    print("매물 생성 실패:", e.localizedDescription)
                }
            } receiveValue: { message in
                onSuccess(message) // message 내린거 받기
            }
            .store(in: &cancellables)
    }

    private func mapPropertyType(_ raw: String) -> String {
        switch raw {
        case "아파트": return "APARTMENT"
        case "빌라": return "VILLA"
        case "오피스텔": return "OFFICETEL"
        case "원룸": return "ONE_ROOM"
        case "기타", "기타 주택": return "OTHER"
        default:
            print("알 수 없는 타입", raw)
            return "OTHER"
        }
    }
}
