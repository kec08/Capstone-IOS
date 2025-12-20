import SwiftUI

struct SavedView: View {
    @StateObject private var viewModel = SavedViewModel()
    @Environment(\.dismiss) var dismiss

    @State private var showAddView = false
    @State private var showAILoading = false
    @State private var showAIResult = false

    // 추가한 로컬 아이템 삽입
    @State private var pendingNewItem: AddCheckListItem?

    var onPropertySelected: ((SavedProperty) -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            SavedHeaderView(
                onBackTapped: { dismiss() },
                onAddTapped: { showAddView = true }
            )

            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.errorMessage {
                errorView(message: error)
            } else if viewModel.properties.isEmpty {
                emptyStateView
            } else {
                propertyListView
            }
        }
        .background(.customWhite)
        .navigationBarHidden(true)

        // Add
        .sheet(isPresented: $showAddView) {
            AddCheckListView(
                addCheckListItem: { newItem in
                    // 로컬로 일단 들고있기
                    pendingNewItem = newItem

                    // 서버 생성(리턴은 message)
                    viewModel.createProperty(from: newItem) { _ in
                        showAddView = false
                        showAILoading = true
                    }
                },
                onDismiss: { showAddView = false }
            )
        }

        // AI 로딩
        .sheet(isPresented: $showAILoading) {
            AILoadingView {
                showAILoading = false
                showAIResult = true
            }
        }

        // AI 결과
        .sheet(isPresented: $showAIResult) {
            AIGeneratedListView(onConfirm: {
                showAIResult = false

                // 체크리스트에 추가 (로컬 아이템 기반으로 SavedProperty 만들어서 넘김)
                if let item = pendingNewItem {
                    let saved = SavedProperty(
                        id: Int.random(in: 1...Int.max),
                        propertyId: Int.random(in: 1...Int.max),
                        image: item.image,
                        type: item.propertyType.displayName,
                        name: item.name,
                        details: item.address,
                        description: item.memo,
                        price: item.displayPrice,
                        createdAt: item.date,
                        floor: item.floor,
                        area: item.area,
                        leaseType: item.leaseType.rawValue,
                        deposit: item.deposit,
                        monthlyRent: item.monthlyRent
                    )
                    onPropertySelected?(saved)
                    pendingNewItem = nil
                    dismiss()
                }
            })
        }
    }

    // 매물 리스트 뷰
    private var propertyListView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.properties) { property in
                    SavedPropertyCard(property: property)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            // 매물 선택 시 CheckListView에 추가
                            onPropertySelected?(property)
                            dismiss()
                        }
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView().scaleEffect(1.5)
            Text("매물 목록을 불러오는 중...")
                .font(.system(size: 14))
                .foregroundColor(.customDarkGray)
                .padding(.top, 16)
            Spacer()
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red.opacity(0.6))

            Text("매물을 불러올 수 없습니다")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)

            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button(action: { viewModel.fetchProperties() }) {
                Text("다시 시도")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Color.cyan)
                    .cornerRadius(8)
            }
            .padding(.top, 8)

            Spacer()
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("관심 매물이 없습니다.")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            Text("홈에서 +버튼을 눌러 매물을 추가해보세요!")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

