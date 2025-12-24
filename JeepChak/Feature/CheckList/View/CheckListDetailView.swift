import SwiftUI
import Combine

struct CheckListDetailView: View {
    let checkItem: CheckItem
    @Binding var items: [CheckItem]
    @State private var detailItems: [DetailItem]
    @State private var showAddItemSheet = false
    @State private var newItemName = ""
    @State private var isLoading = false

    @Environment(\.dismiss) private var dismiss

    private let checklistService = ChecklistService()
    @State private var cancellables = Set<AnyCancellable>()

    // 헤더 높이
    private let headerHeight: CGFloat = 56
    /// Final(저장된 체크리스트)에서 '수정'으로 들어온 경우, Final에서 다시 '확인' 버튼을 보여주기 위한 플래그
    private let isEditingSavedChecklist: Bool

    init(checkItem: CheckItem, items: Binding<[CheckItem]>, isEditingSavedChecklist: Bool = false) {
        self.checkItem = checkItem
        self._items = items
        self._detailItems = State(initialValue: checkItem.detailItems.isEmpty ? [] : checkItem.detailItems)
        self.isEditingSavedChecklist = isEditingSavedChecklist
    }

    var body: some View {
        ZStack(alignment: .top) {

            content
                .padding(.top, headerHeight)

            CheckListDetailHeaderView(onBackTapped: { dismiss() })
                .frame(maxWidth: .infinity)
                .frame(height: headerHeight)
                .background(Color.white)
                .zIndex(10)
        }
        .background(Color.white)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if let propertyId = checkItem.propertyId, detailItems.isEmpty {
                loadChecklistForProperty(propertyId: propertyId)
            } else if detailItems.isEmpty {
                detailItems = defaultItems()
            }
        }
        .sheet(isPresented: $showAddItemSheet) {
            AddCheckItemSheet(
                newItemName: $newItemName,
                onAdd: {
                    if !newItemName.isEmpty {
                        detailItems.append(DetailItem(name: newItemName))
                        newItemName = ""
                        showAddItemSheet = false
                    }
                },
                onDismiss: {
                    showAddItemSheet = false
                    newItemName = ""
                }
            )
        }
    }

    private var content: some View {
        ScrollView {
            VStack(spacing: 12) {

                Text("\(checkItem.title) 체크리스트")
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                    .padding(.bottom, 4)
            
                VStack(spacing: 12) {
                    ForEach($detailItems) { $item in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Text(item.name)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                Spacer()
                                StatusButtonView(selectedStatus: $item.status)
                            }
                            
                            TextField("메모", text: $item.memo)
                                .padding(12)
                                .cornerRadius(8)
                                .font(.system (size: 14))
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 2)
                    }
                    
                    Button(action: { showAddItemSheet = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Text("추가로 작성하실 체크리스트를 입력해주세요")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 22)
                    }
                
                    NavigationLink(
                        destination: CheckListFinalView(
                            checkItem: checkItem,
                            detailItems: detailItems,
                            items: $items,
                            onExitToList: { dismiss() },
                            forceShowConfirm: isEditingSavedChecklist
                        )
                    ) {
                    Text("확인")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)

                // 스크롤 여백
                Color.clear.frame(height: 30)
            }
        }
                .background(Color.white)
    }

    private func defaultItems() -> [DetailItem] {
        [
            .init(name: "화장실 곰팡이 확인하기"),
            .init(name: "벽과 바닥 상태 확인하기"),
            .init(name: "창문 틈새 확인하기"),
            .init(name: "수압 확인하기"),
            .init(name: "보일러 확인하기")
        ]
    }

    private func loadChecklistForProperty(propertyId: Int) {
        isLoading = true
        let request = ChecklistGenerateRequest(propertyId: propertyId)

        checklistService.generateChecklist(request: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                isLoading = false
                if case .failure = completion {
                    detailItems = defaultItems()
                }
            } receiveValue: { responses in
                isLoading = false
                var allDetailItems: [DetailItem] = []

                for response in responses {
                    if let contents = response.contents {
                        for content in contents {
                            var trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)

                            // JSON 마커만 제거 (실제 체크리스트 항목은 보존)
                            if trimmed == "```json" || trimmed == "```" || trimmed == "{" || trimmed == "}" ||
                                trimmed == "\"contents\": [" || trimmed == "]" ||
                                (trimmed.hasPrefix("\"contents\":") && !trimmed.contains("확인") && !trimmed.contains("점검") && !trimmed.contains("평가")) {
                                continue
                            }

                            if trimmed.isEmpty { continue }

                            // 앞뒤 따옴표 제거 (하지만 내용이 있는 경우만)
                            if trimmed.hasPrefix("\"") && trimmed.count > 1 {
                                trimmed = String(trimmed.dropFirst())
                            }
                            if trimmed.hasSuffix("\"") && trimmed.count > 1 {
                                trimmed = String(trimmed.dropLast())
                            }
                            if trimmed.hasSuffix("\",") {
                                trimmed = String(trimmed.dropLast(2))
                            }

                            trimmed = trimmed.replacingOccurrences(of: "\\\"", with: "\"")
                            trimmed = trimmed.trimmingCharacters(in: .whitespacesAndNewlines)

                            // 최소 길이 체크 (너무 짧은 항목은 제외)
                            if !trimmed.isEmpty && trimmed.count >= 3 {
                                allDetailItems.append(.init(name: trimmed))
                    }
                        }
                    }
                }

                if !allDetailItems.isEmpty {
                    detailItems = allDetailItems
                    if let index = items.firstIndex(where: { $0.id == checkItem.id }) {
                        items[index].detailItems = allDetailItems
                    }
                } else {
                    detailItems = defaultItems()
        }
    }
            .store(in: &cancellables)
    }
}


struct CheckListDetailView_Previews: PreviewProvider {
    static var previews: some View {
            CheckListDetailView(
                checkItem: CheckItem(title: "봉양면 ㅇㅇ주택", date: "2025-09-16", imageName: "CheckListHouse1", image: nil, propertyId: nil),
                items: .constant([])
            )
    }
}
