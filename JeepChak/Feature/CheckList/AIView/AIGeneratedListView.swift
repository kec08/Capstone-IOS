//
//  AIGeneratedListView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/1/25.
//

import SwiftUI

struct AIGeneratedListView: View {
    var onConfirm: ([AICheckItem]) -> Void // 선택된 항목들을 전달

    @State private var items: [AICheckItem]
    @State private var showAddSheet = false
    @State private var newItem = ""
    
    init(checklistItems: [AICheckItem] = [], onConfirm: @escaping ([AICheckItem]) -> Void) {
        self.onConfirm = onConfirm
        // API에서 받은 항목이 있으면 사용, 없으면 빈 배열 (기본값 제거)
        self._items = State(initialValue: checklistItems)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("AI가 생성한 체크리스트")
                .font(.system(size: 20, weight: .semibold))
                .padding(.top, 24)
                .padding(.bottom, 12)
                .foregroundColor(Color.customBlack)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if items.isEmpty {
                        // API 응답이 null이거나 빈 배열인 경우
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 48))
                                .foregroundColor(.orange)
                            
                            Text("AI가 생성한 체크리스트가 없습니다")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Text("아래 버튼을 눌러 직접 추가해주세요")
                                .font(.system(size: 14))
                                .foregroundColor(.gray.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        ForEach($items) { $item in
                            HStack(spacing: 10) {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        item.isChecked.toggle()
                                    }
                                }) {
                                    Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                                        .foregroundColor(item.isChecked ? .cyan : .gray)
                                        .font(.system(size: 22))
                                }
                                .buttonStyle(.plain)

                                Text(item.name)
                                    .font(.system(size: 16))
                                    .foregroundColor(.customBlack)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)

                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    Button(action: {
                        showAddSheet = true
                    }) {
                        HStack(spacing: 8) {
                            Text("+")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.gray)
                            Text("추가로 작성하실 체크리스트를 입력해주세요")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }

            Button(action: {
                // 선택된 항목들(체크된 항목들)을 전달
                let selectedItems = items.filter { $0.isChecked }
                onConfirm(selectedItems.isEmpty ? items : selectedItems) // 아무것도 선택 안 하면 전체 전달
            }) {
                Text("확인")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cyan)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
        .sheet(isPresented: $showAddSheet) {
            AddChecklistSheet(
                newItem: $newItem,
                onAdd: {
                    if !newItem.isEmpty {
                        items.append(AICheckItem(name: newItem))
                        newItem = ""
                    }
                    showAddSheet = false
                },
                onDismiss: {
                    newItem = ""
                    showAddSheet = false
                }
            )
        }
    }
}

#Preview {
    AIGeneratedListView(onConfirm: { _ in })
}

