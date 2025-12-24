import SwiftUI

struct MapView: View {
    private let filterTypes: Set<String>?
    private let showsCompactHeader: Bool
    private let showsBackButton: Bool
    private let initialSelectedPropertyId: Int?
    @StateObject private var viewModel: MapViewModel
    @Environment(\.dismiss) private var dismiss

    init(
        filterTypes: Set<String>? = nil,
        showsCompactHeader: Bool = false,
        showsBackButton: Bool = false,
        initialSelectedPropertyId: Int? = nil
    ) {
        self.filterTypes = filterTypes
        self.showsCompactHeader = showsCompactHeader
        self.showsBackButton = showsBackButton
        self.initialSelectedPropertyId = initialSelectedPropertyId
        _viewModel = StateObject(wrappedValue: MapViewModel(filterTypes: filterTypes))
    }

    var body: some View {
        ZStack {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                Color.gray.opacity(0.15).ignoresSafeArea()
            } else {
                VStack(spacing: 0) {
                    // 탭(기본) 진입: 기존 헤더(검색 포함)
                    if !showsCompactHeader {
                        HomeHeaderView()
                            .padding(.horizontal, 20)
                            .padding(.trailing, 24)
                            .padding(.top, 10)
                            .padding(.bottom, 16)
                            .background(Color.customBackgroundBlue)
                    }

                    NaverMapViewRepresentable(
                        centerLat: .init(
                            get: { viewModel.centerLat },
                            set: { viewModel.centerLat = $0 }
                        ),
                        centerLng: .init(
                            get: { viewModel.centerLng },
                            set: { viewModel.centerLng = $0 }
                        ),
                        properties: viewModel.properties,
                        onTapProperty: { property in
                            viewModel.selectProperty(property)
                        }
                    )
                    .ignoresSafeArea()
                }
            }
        }
        // 홈에서 push로 진입한 경우: 네비게이션 바를 사용(기본 back 버튼 1개만) + 배경을 연한 파랑으로 노치까지 채움
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if showsCompactHeader {
                ToolbarItem(placement: .principal) {
                    Image("Header_AppIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 28)
                }
            }
        }
        .toolbarBackground(Color.customBackgroundBlue, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar(showsCompactHeader ? .visible : .hidden, for: .navigationBar)
        .onAppear {
            // RecentPropertyCard에서 진입 시 해당 매물 시트 자동 오픈
            if let id = initialSelectedPropertyId {
                viewModel.selectPropertyById(id)
            }
        }
        .sheet(isPresented: .init(
            get: { viewModel.isDetailPresented },
            set: { viewModel.isDetailPresented = $0 }
        )) {
            if let property = viewModel.selectedProperty {
                PropertyDetailSheet(
                    property: property,
                    onClose: { viewModel.closeDetail() }
                )
            }
        }
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
            MapView()
    }
}
