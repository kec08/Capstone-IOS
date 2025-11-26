import SwiftUI

struct PropertyUploadView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SavedViewModel
    
    let onPropertySelected: (SavedProperty) -> Void
    @State private var selectedId: Int? = nil
    
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
                isEnabled: selectedId != nil
            ) {
                guard
                    let id = selectedId,
                    let property = viewModel.properties.first(where: { $0.id == id })
                else { return }
                
                onPropertySelected(property)
                dismiss()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
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

#Preview("mock") {
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
                    createdAt: "2025-11-15"
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
                    createdAt: "2025-11-10"
                )
            ]
        ) { _ in }
    }
}
