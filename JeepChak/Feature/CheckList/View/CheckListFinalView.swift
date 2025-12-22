import SwiftUI

struct CheckListFinalView: View {
    let checkItem: CheckItem
    let detailItems: [DetailItem]
    @Binding var items: [CheckItem]

    @State private var showAIReport = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode

    private let headerHeight: CGFloat = 56

    var body: some View {
        ZStack(alignment: .top) {

            content
                .padding(.top, headerHeight)

            header
                .frame(maxWidth: .infinity)
                .frame(height: headerHeight)
                .background(Color.customWhite)
                .zIndex(10)
        }
        .background(Color.customWhite)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showAIReport) {
            AIResultView()
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(.customBlack)
            }

            Spacer()

            Text("체크리스트")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)

            Spacer()

            NavigationLink(destination: CheckListDetailView(checkItem: checkItem, items: $items)) {
                Text("수정")
                    .font(.system(size: 16))
                    .foregroundColor(.customBlack)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
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
                                    .foregroundColor(.customBlack)

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
                        .shadow(color: Color.customBlack.opacity(0.05), radius: 2)
                    }

                    Button(action: {
                        if let index = items.firstIndex(where: { $0.id == checkItem.id }) {
                            items[index].detailItems = detailItems
                        }
                        presentationMode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("확인")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.cyan)
                            .cornerRadius(12)
                    }
                    .padding(.top, 8)
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
}
