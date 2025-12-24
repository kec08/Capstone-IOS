import SwiftUI
import Combine

struct CheckListFinalView: View {
    let checkItem: CheckItem
    let detailItems: [DetailItem]
    @Binding var items: [CheckItem]
    /// Detail에서 진입했을 때, 저장 후 Detail까지 닫아 CheckListView로 복귀시키기 위한 콜백
    var onExitToList: () -> Void = {}
    /// 저장된 체크리스트라도 '수정' 플로우로 들어온 경우에는 확인 버튼을 다시 노출하고 PUT 업데이트를 수행
    var forceShowConfirm: Bool = false

    @State private var showAIReport = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode

    private let headerHeight: CGFloat = 56
    private let checklistService = ChecklistService()
    @State private var cancellables = Set<AnyCancellable>()
    @State private var isSaving = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack(alignment: .top) {

            content
                .padding(.top, headerHeight)

            header
                .frame(maxWidth: .infinity)
                .frame(height: headerHeight)
                .background(Color("customWhite"))
                .zIndex(10)
        }
        .background(Color("customWhite"))
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showAIReport) {
            AIResultView()
        }
        .alert("저장 실패", isPresented: $showErrorAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(Color("customBlack"))
            }

            Spacer()

            Text("체크리스트")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)

            Spacer()

            NavigationLink(destination: CheckListDetailView(checkItem: checkItem, items: $items, isEditingSavedChecklist: true)) {
                Text("수정")
                    .font(.system(size: 16))
                    .foregroundColor(Color("customBlack"))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var isAlreadySaved: Bool {
        items.first(where: { $0.id == checkItem.id })?.isSaved ?? checkItem.isSaved
    }

    private var currentChecklistId: Int? {
        items.first(where: { $0.id == checkItem.id })?.checklistId ?? checkItem.checklistId
    }

    // MARK: - Content
    private var content: some View {
        ScrollView {
            VStack(spacing: 16) {

                Text(checkItem.title)
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 4)

                VStack(spacing: 16) {
                    ForEach(detailItems) { item in
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.name)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color("customBlack"))

                                if !item.memo.isEmpty {
                                    Text(item.memo)
                                        .font(.system(size: 14))
                                        .foregroundColor(memoColor(for: item.status))
                                        .lineLimit(2)
                                }
                            }

                            Spacer()

                            StatusIndicatorView(status: item.status)
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color("customBlack").opacity(0.05), radius: 2)
                    }

                    // 저장 완료된 체크리스트는 기본적으로 확인 버튼 숨김
                    // 단, Final에서 '수정'으로 들어왔다가 온 경우(forceShowConfirm)에는 다시 노출
                    if !isAlreadySaved || forceShowConfirm {
                        Button(action: saveAndExitToList) {
                            Text(isSaving ? "저장 중..." : "확인")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.cyan)
                                .cornerRadius(12)
                        }
                        .disabled(isSaving)
                        .opacity(isSaving ? 0.7 : 1.0)
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 20)

                Color.clear.frame(height: 30)
            }
            .padding(.bottom, 20)
        }
    }

    // MARK: - Helpers
    private func memoColor(for status: String) -> Color {
        switch status {
        case "checkmark": return .cyan
        case "warning":   return .orange
        case "danger":    return .red
        default:          return .gray
        }
    }

    private func severityInt(for status: String) -> Int {
        switch status {
        case "none":      return 0
        case "checkmark": return 1
        case "warning":   return 2
        case "danger":    return 3
        default:          return 0
        }
    }

    private func severityString(for status: String) -> String {
        switch status {
        case "none":      return "NONE"
        case "checkmark": return "NORMAL"
        case "warning":   return "WARNING"
        case "danger":    return "DANGER"
        default:          return "NONE"
        }
    }

    private func saveAndExitToList() {
        guard !isSaving else { return }
        isSaving = true

        // 1) 저장된 체크리스트를 '수정' 플로우로 들어온 경우: PUT /api/checklist/{id}
        if isAlreadySaved && forceShowConfirm {
            guard let checklistId = currentChecklistId else {
                isSaving = false
                errorMessage = "checklistId가 없어 체크리스트를 수정 저장할 수 없습니다."
                showErrorAlert = true
                return
            }

            let updates: [ChecklistUpdateRequest] = detailItems.map { item in
                ChecklistUpdateRequest(
                    itemId: item.serverItemId,
                    memo: item.memo,
                    severity: severityString(for: item.status)
                )
            }

            checklistService.updateChecklist(id: checklistId, items: updates)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    isSaving = false
                    if case .failure(let err) = completion {
                        errorMessage = err.localizedDescription
                        showErrorAlert = true
                    }
                } receiveValue: { _ in
                    if let index = items.firstIndex(where: { $0.id == checkItem.id }) {
                        items[index].detailItems = detailItems
                        items[index].isSaved = true
                        items[index].checklistId = checklistId
                    }
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        onExitToList()
                    }
                }
                .store(in: &cancellables)
            return
        }

        // 2) 신규 체크리스트 저장: POST /api/checklist
        guard let propertyId = checkItem.propertyId else {
            isSaving = false
            errorMessage = "매물 ID(propertyId)가 없어 체크리스트를 저장할 수 없습니다."
            showErrorAlert = true
            return
        }

        let saveItems: [ChecklistSaveItem] = detailItems.map { item in
            ChecklistSaveItem(
                content: item.name,
                severity: severityString(for: item.status),
                memo: item.memo   // 빈 문자열이어도 key 포함해서 전송
            )
        }

        let request = ChecklistSaveRequest(propertyId: propertyId, items: saveItems)

        checklistService.saveChecklist(request: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                isSaving = false
                if case .failure(let err) = completion {
                    errorMessage = err.localizedDescription
                    showErrorAlert = true
                }
            } receiveValue: { response in
                // 로컬 상태 업데이트(저장됨 처리)
                if let index = items.firstIndex(where: { $0.id == checkItem.id }) {
                    items[index].detailItems = detailItems
                    items[index].isSaved = true
                    items[index].checklistId = response.checklistId
                }

                // Final 먼저 닫고, 이어서 Detail까지 닫아서 CheckListView로 복귀
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    onExitToList()
                }
            }
            .store(in: &cancellables)
    }
}
