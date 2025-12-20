//
//  CheckListFinalView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/2/25.
//

import SwiftUI

struct CheckListFinalView: View {
    let checkItem: CheckItem
    let detailItems: [DetailItem]
    @Binding var items: [CheckItem]
    @State private var showAIReport = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                // 헤더
                CheckListFinalHeaderView(
                    onBackTapped: {
                        dismiss()
                    },
                    onEditTapped: {
                        dismiss()
                    }
                )
                
                // 타이틀
                Text(checkItem.title)
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(detailItems) { item in
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.name)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
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
                            .shadow(color: Color.black.opacity(0.05), radius: 2)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .background(Color.customWhite)
            
            // 저장 버튼
            VStack {
                Spacer()
                Button(action: {
                    // CheckItem의 detailItems 업데이트
                    if let index = items.firstIndex(where: { $0.id == checkItem.id }) {
                        items[index].detailItems = detailItems
                    }
                    // CheckListView로 바로 돌아가기 (NavigationLink 스택에서 두 번 pop)
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        dismiss()
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
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
                .background(
                    Color.white
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                )
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showAIReport) {
            AIResultView()
        }
    }
    
    // 상태에 따른 메모 색상 반환
    private func memoColor(for status: String) -> Color {
        switch status {
        case "checkmark":
            return Color.cyan
        case "warning":
            return Color.orange
        case "danger":
            return Color.red
        default:
            return Color.gray
        }
    }
}
