import SwiftUI
import Combine

final class AddCheckListViewModel: ObservableObject {

    enum Field: Hashable {
        case name, address, floor, area, builtYear, marketPrice, deposit, monthlyRent, memo
    }

    // MARK: - UI State
    @Published var selectedImage: UIImage?
    @Published var isImagePickerPresented: Bool = false

    // 완료 메시지
    @Published var showMessageSheet: Bool = false
    @Published var serverMessage: String = ""

    // 로딩/에러
    @Published var isSubmitting: Bool = false
    @Published var errorMessage: String?

    // MARK: - Inputs
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var propertyType: PropertyType = .ONE_ROOM

    @Published var floor: String = ""
    @Published var area: String = ""
    @Published var builtYear: String = ""
    @Published var marketPrice: String = ""

    @Published var leaseType: LeaseType = .monthly
    @Published var deposit: String = ""
    @Published var monthlyRent: String = ""

    @Published var memo: String = ""

    // MARK: - Services
    private let propertyService = PropertyService()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Derived
    var displayPriceText: String {
        let dep = int(from: deposit)
        let mon = int(from: monthlyRent)

        switch leaseType {
        case .jeonse:
            guard let dep else { return "" }
            return "전세 \(formatNumber(dep))"
        case .monthly:
            guard let dep else { return "" }
            let monText = mon.map(formatNumber) ?? "?"
            return "월세 \(formatNumber(dep))/\(monText)"
        }
    }

    var isValid: Bool {
        if name.trimmed.isEmpty { return false }
        if address.trimmed.isEmpty { return false }
        if int(from: floor) == nil { return false }
        if int(from: area) == nil { return false }
        if int(from: builtYear) == nil { return false }
        if int(from: marketPrice) == nil { return false }
        if int(from: deposit) == nil { return false }
        if leaseType == .monthly && int(from: monthlyRent) == nil { return false }
        return true
    }

    // MARK: - 서버 요청 payload
    func createPropertyRequest() -> PropertyRequest {
        PropertyRequest(
            name: name.trimmed,
            address: address.trimmed,
            propertyType: propertyType.rawValue,
            floor: int(from: floor) ?? 0,
            builtYear: int(from: builtYear) ?? 0,
            area: int(from: area) ?? 0,
            marketPrice: int(from: marketPrice) ?? 0,
            leaseType: leaseType.rawValue,           // MONTHLY_RENT / JEONSE
            deposit: int(from: deposit) ?? 0,
            monthlyRent: leaseType == .monthly ? (int(from: monthlyRent) ?? 0) : 0,
            memo: memo.trimmed
        )
    }

    // 추가하기 버튼에서 이거만 호출
    func submitCreateProperty(onSuccess: @escaping () -> Void) {
        guard !isSubmitting else { return }
        errorMessage = nil
        isSubmitting = true

        let payload = createPropertyRequest()
        print("payload:", payload)

        propertyService.createProperty(request: payload)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isSubmitting = false
                if case .failure(let err) = completion {
                    self.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] message in
                guard let self else { return }
                // 서버 응답이 "success"나 빈 문자열이면 사용자 친화적인 메시지로 변경
                let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                if trimmedMessage.isEmpty || trimmedMessage == "success" || trimmedMessage == "매물이 생성되었습니다." {
                    self.serverMessage = "매물 추가가 완료되었습니다!"
                } else {
                    self.serverMessage = message
                }
                self.showMessageSheet = true
                onSuccess()
            }
            .store(in: &cancellables)
    }

    // MARK: - Helpers
    private func int(from text: String) -> Int? {
        let filtered = text.replacingOccurrences(of: ",", with: "").trimmed
        return Int(filtered)
    }

    private func formatNumber(_ n: Int) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: n)) ?? "\(n)"
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
