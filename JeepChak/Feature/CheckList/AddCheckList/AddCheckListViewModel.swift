import SwiftUI
import Combine
import Moya
import CombineMoya

final class AddCheckListViewModel: ObservableObject {
    
    enum Field: Hashable {
        case title, address, propertyType, unit, memo
    }
    
    @Published var title = ""
    @Published var address = ""
    @Published var propertyType = ""
    @Published var unit = ""
    @Published var memo = ""
    @Published var selectedImage: UIImage?
    @Published var isImagePickerPresented = false
    @Published var showAILoading = false
    @Published var showAIResult = false
    @Published var focusedField: Field?
    
    private let checklistService = ChecklistService()
    private var cancellables = Set<AnyCancellable>()
    
    var isValid: Bool {
        !title.isEmpty
    }
    
    func createCheckListItem() -> AddCheckListItem {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        
        return AddCheckListItem(
            image: selectedImage,
            title: title,
            address: address,
            propertyType: propertyType,
            unit: unit,
            memo: memo,
            date: currentDate
        )
    }
    
    // MARK: - 서버 업로드
    func uploadChecklist(_ propertyId: Int) {
        showAILoading = true

        let request = ChecklistGenerateRequest(propertyId: propertyId)
        
        if let data = try? JSONEncoder().encode(request),
               let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }


        checklistService.generateChecklist(request: request)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.showAILoading = false

                switch completion {
                case .finished:
                    print("체크리스트 생성 완료")
                    self.showAIResult = true
                case .failure(let error):
                    print("자동 생성 실패:", error.localizedDescription)
                    self.showAIResult = false
                }
            } receiveValue: { response in
                print("생성된 체크리스트:", response)
            }
            .store(in: &cancellables)
    }
    
    func generateChecklist(_ propertyId: Int) {
        uploadChecklist(propertyId)
    }

}
