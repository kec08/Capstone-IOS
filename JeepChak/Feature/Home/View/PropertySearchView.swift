import SwiftUI

/// 홈 헤더 검색바 탭 시 진입하는 "검색" 전용 페이지
struct PropertySearchView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var source = MapViewModel()

    @State private var query: String = ""
    @State private var didSearch: Bool = false
    @State private var results: [MapProperty] = []
    @State private var selectedPropertyId: Int? = nil

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 20)
                .padding(.top, 6)

            content
                .padding(.horizontal, 20)
                .padding(.top, 18)
        }
        .background(Color("customWhite"))
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: .init(
            get: { selectedPropertyId != nil },
            set: { if !$0 { selectedPropertyId = nil } }
        )) {
            if let id = selectedPropertyId {
                MapView(
                    showsCompactHeader: true,
                    showsBackButton: true,
                    initialSelectedPropertyId: id
                )
            }
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack(spacing: 12) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color("customBlack"))
                    .frame(width: 36, height: 36)
            }

            searchBar
        }
        .padding(.bottom, 10)
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            TextField("찾으시는 방을 검색해보세요", text: $query)
                .font(.system(size: 14))
                .foregroundColor(Color("customBlack"))
                .submitLabel(.search)
                .onSubmit { triggerSearch() }

            Button(action: triggerSearch) {
                Image("Search_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color("customGray300"))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .cornerRadius(14)
    }

    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        if !didSearch {
            recommendationEmptyView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if results.isEmpty {
            Text("키워드가 없습니다")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("customBlack"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 18) {
                    ForEach(results, id: \.id) { property in
                        Button {
                            selectedPropertyId = property.id
                        } label: {
                            SearchResultCard(property: property, imageName: placeholderImageName(for: property.id))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.bottom, 24)
            }
        }
    }

    private var recommendationEmptyView: some View {
        VStack(spacing: 14) {
            Image("Search_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)

            Text("검색 키워드 추천")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color("customBlack"))

            Text("주소, 매물이름, 지역, 매물번호를\n넣어 더욱 자세한 매물을 찾아보세요!")
                .font(.system(size: 15))
                .foregroundColor(Color("customDarkGray"))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 140)
    }

    // MARK: - Logic
    private func triggerSearch() {
        didSearch = true

        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else {
            results = []
            return
        }

        results = source.searchProperties(query: q)
    }

    private func placeholderImageName(for propertyId: Int) -> String {
        let pool = (1...14).map { "property_\($0)" }
        return pool[abs(propertyId) % pool.count]
    }
}

private struct SearchResultCard: View {
    let property: MapProperty
    let imageName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 190)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(14)

            VStack(alignment: .leading, spacing: 6) {
                Text(property.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("customBlack"))

                Text(property.displayPrice)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("customBlack"))

                Text("\(property.displayPropertyType)   \(property.floor)층 \(property.area)평")
                    .font(.system(size: 13))
                    .foregroundColor(Color("customDarkGray"))

                Text(property.address)
                    .font(.system(size: 13))
                    .foregroundColor(Color("customDarkGray"))
                    .lineLimit(2)

                if !property.memo.isEmpty {
                    Text(property.memo)
                        .font(.system(size: 13))
                        .foregroundColor(Color("customGray300"))
                        .lineLimit(2)
                }
            }
            .padding(.horizontal, 4)
        }
    }
}


