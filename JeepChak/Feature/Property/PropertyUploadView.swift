import SwiftUI
import Combine
import UIKit

struct PropertyUploadView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SavedViewModel
    
    let onPropertySelected: (SavedProperty) -> Void
    @State private var selectedId: Int? = nil
    @State private var isFetchingDetail: Bool = false
    @State private var errorMessage: String?
    private let propertyService = PropertyService()
    @State private var cancellables = Set<AnyCancellable>()
    
    init(onPropertySelected: @escaping (SavedProperty) -> Void) {
        _viewModel = StateObject(wrappedValue: SavedViewModel())
        self.onPropertySelected = onPropertySelected
    }
    
    init(
        properties: [SavedProperty],
        onPropertySelected: @escaping (SavedProperty) -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: SavedViewModel(mockProperties: properties)
        )
        self.onPropertySelected = onPropertySelected
    }
    
    var body: some View {
        VStack(spacing: 0) {
            PropertyUploadHeaderView(
                title: "매물 업로드",
                onBack: { dismiss() }
            )
            
            contentView
            
            PropertyUploadBottomButton(
                title: "업로드 하기",
                isEnabled: selectedId != nil && !isFetchingDetail
            ) {
                guard
                    let id = selectedId,
                    let property = viewModel.properties.first(where: { $0.id == id })
                else { return }
                
                // ✅ 분석에 필요한 marketPrice(시세)를 보장하기 위해 상세조회 후 전달
                isFetchingDetail = true
                errorMessage = nil
                propertyService.getPropertyDetail(id: property.propertyId)
                    .map { SavedProperty.from($0) }
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        isFetchingDetail = false
                        if case .failure(let e) = completion {
                            // 상세 조회 실패 시에도 기존 선택값으로 진행(시세는 deposit fallback 될 수 있음)
                            errorMessage = e.localizedDescription
                onPropertySelected(property)
                dismiss()
                        }
                    } receiveValue: { detailed in
                        var enriched = detailed
                        enriched.image = property.image
                        onPropertySelected(enriched)
                        dismiss()
                    }
                    .store(in: &cancellables)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
        .alert("매물 정보 불러오기 실패", isPresented: .constant(errorMessage != nil)) {
            Button("확인") { errorMessage = nil }
        } message: {
            if let msg = errorMessage { Text(msg) }
        }
    }
}

private extension PropertyUploadView {
    @ViewBuilder
    var contentView: some View {
        if viewModel.isLoading {
            PropertyUploadLoadingView()
        } else if let error = viewModel.errorMessage {
            PropertyUploadErrorView(
                message: error,
                onRetry: { viewModel.fetchProperties() }
            )
        } else if viewModel.properties.isEmpty {
            PropertyUploadEmptyView()
        } else {
            listView
        }
    }
    
    var listView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.properties) { property in
                    Button {
                        selectedId = property.id
                    } label: {
                        SavedPropertyCard(property: property)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(
                                color: selectedId == property.id
                                ? Color.customBlue.opacity(0.5)
                                : Color.clear,
                                radius: 5
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 8)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }

}


struct PropertyUploadView_Previews: PreviewProvider {
    static var previews: some View {
            NavigationView {
                PropertyUploadView(
                    properties: [
                        SavedProperty(
                            id: 1,
                            propertyId: 1,
                            image: UIImage(contentsOfFile: "CheckListHouse1"),
                            type: "원룸",
                            name: "성수동 풀옵션 원룸",
                            details: "서울 성동구 성수동1가",
                            description: "채광 좋고 주변 조용함",
                            price: "월세 80/10",
                            marketPrice: 15000,
                            createdAt: "2025-11-15",
                            floor: 3,
                            area: 20,
                            leaseType: "MONTHLY_RENT",
                            deposit: 80,
                            monthlyRent: 10
                        ),
                        SavedProperty(
                            id: 2,
                            propertyId: 2,
                            image: UIImage(contentsOfFile: "CheckListHouse2"),
                            type: "투룸",
                            name: "역삼역 도보 3분 투룸",
                            details: "서울 강남구 역삼동",
                            description: "회사와 가까움",
                            price: "전세 4.5억",
                            marketPrice: 450000000,
                            createdAt: "2025-11-10",
                            floor: 5,
                            area: 30,
                            leaseType: "JEONSE",
                            deposit: 450000000,
                            monthlyRent: 0
                        )
                    ]
                ) { _ in }
            }
    }
}
