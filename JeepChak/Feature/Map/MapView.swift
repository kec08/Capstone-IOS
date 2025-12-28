import SwiftUI

struct MapView: View {
    private let filterTypes: Set<String>?
    private let showsCompactHeader: Bool
    private let showsBackButton: Bool
    private let initialSelectedPropertyId: Int?
    private let initialSearchQuery: String?
    @StateObject private var viewModel: MapViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showSearch: Bool = false
    @State private var quickFilter: MapQuickFilter = .oneRoomVilla

    init(
        filterTypes: Set<String>? = nil,
        showsCompactHeader: Bool = false,
        showsBackButton: Bool = false,
        initialSelectedPropertyId: Int? = nil,
        initialSearchQuery: String? = nil
    ) {
        self.filterTypes = filterTypes
        self.showsCompactHeader = showsCompactHeader
        self.showsBackButton = showsBackButton
        self.initialSelectedPropertyId = initialSelectedPropertyId
        self.initialSearchQuery = initialSearchQuery
        _viewModel = StateObject(wrappedValue: MapViewModel(filterTypes: filterTypes))
    }

    var body: some View {
        ZStack {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                Color.gray.opacity(0.15).ignoresSafeArea()
            } else {
                ZStack(alignment: .top) {
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

                    if !showsCompactHeader {
                        VStack(spacing: 0) {
                            VStack(spacing: 10) {
                                HomeHeaderView(onTapSearchArea: { showSearch = true })
                                    .padding(.horizontal, 20)
                                    .padding(.trailing, 24)
                                    .padding(.top, 10)

                                MapQuickFilterBar(selected: $quickFilter)
                                    .padding(.horizontal, 20)
                            }
                            .padding(.bottom, 10)
                            .background(Color.customBackgroundBlue.ignoresSafeArea(edges: .top))

                            MapTopCardCarousel(
                                properties: Array(viewModel.properties.prefix(5)),
                                onTap: { property in
                                    viewModel.selectProperty(property)
                                }
                            )
                            .padding(.horizontal, 12)
                            .padding(.top, 10)

                            Spacer(minLength: 0)
                        }
                    }
                }
            }
        }
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
            // 기본 탭 필터
            applyQuickFilter()

            // RecentPropertyCard에서 진입 시 해당 매물 시트 자동 오픈
            if let id = initialSelectedPropertyId {
                viewModel.selectPropertyById(id)
                return
            }
            if let q = initialSearchQuery?.trimmingCharacters(in: .whitespacesAndNewlines), !q.isEmpty {
                _ = viewModel.selectPropertyByQuery(q)
            }
        }
        .onChange(of: quickFilter) { _ in
            applyQuickFilter()
        }
        .fullScreenCover(isPresented: $showSearch) {
            NavigationStack {
                PropertySearchView()
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

    private func applyQuickFilter() {
        // 이미 외부에서 필터가 넘어온 경우(홈 카테고리 진입 등)에는 유지
        if let filterTypes, !filterTypes.isEmpty {
            viewModel.activePropertyTypes = filterTypes
            // UI 선택값도 대략 맞춰줌
            if filterTypes.contains("APARTMENT") || filterTypes.contains("OFFICETEL") {
                quickFilter = .aptOfficetel
            } else if filterTypes.contains("ONE_ROOM") || filterTypes.contains("VILLA") {
                quickFilter = .oneRoomVilla
            }
            return
        }
        viewModel.activePropertyTypes = quickFilter.types
    }
}

// MARK: - Quick Filter UI (원룸/빌라 vs 아파트/오피스텔)
private enum MapQuickFilter: String, CaseIterable, Identifiable {
    case oneRoomVilla = "원룸/빌라"
    case aptOfficetel = "아파트/오피스텔"

    var id: String { rawValue }

    var types: Set<String> {
        switch self {
        case .oneRoomVilla:
            return ["ONE_ROOM", "VILLA"]
        case .aptOfficetel:
            return ["APARTMENT", "OFFICETEL"]
        }
    }
}

private struct MapQuickFilterBar: View {
    @Binding var selected: MapQuickFilter

    var body: some View {
        HStack(spacing: 22) {
            ForEach(MapQuickFilter.allCases) { item in
                Button {
                    selected = item
                } label: {
                    VStack(spacing: 6) {
                        Text(item.rawValue)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(selected == item ? Color("customBlack") : Color("customDarkGray"))

                        Capsule()
                            .fill(selected == item ? Color("customBlack") : Color.clear)
                            .frame(height: 1.5)
                            .frame(width: 56)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            Spacer()
        }
        .padding(.top, 2)
    }
}

// MARK: - Top Cards
private struct MapTopCardCarousel: View {
    let properties: [MapProperty]
    let onTap: (MapProperty) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(properties) { property in
                    Button {
                        onTap(property)
                    } label: {
                        MapTopPropertyCard(
                            property: property,
                            imageName: placeholderImageName(for: property.id)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 6)
        }
    }

    private func placeholderImageName(for propertyId: Int) -> String {
        let pool = (1...14).map { "property_\($0)" }
        let normalized = abs(propertyId)
        let index = (normalized == 0) ? 0 : (normalized - 1) % pool.count
        return pool[index]
    }
}

private struct MapTopPropertyCard: View {
    let property: MapProperty
    let imageName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 148, height: 86)
                .clipped()

            VStack(alignment: .leading, spacing: 6) {
                Text("경북 의성군")
                    .font(.system(size: 9))
                    .foregroundColor(Color("customDarkGray"))

                Text(property.name)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color("customBlack"))
                    .lineLimit(1)

                Text(property.displayPrice.replacingOccurrences(of: "만원", with: ""))
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color("customBlack"))
            }
            .padding(10)
            .background(Color.white)
        }
        .frame(width: 148)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
            MapView()
    }
}
