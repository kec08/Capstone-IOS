//
//  AIGeneratedListView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/1/25.
//

import SwiftUI

struct AIGeneratedListView: View {
    var onConfirm: () -> Void

    @State private var checklistItems: [AICheckItem] = [
        AICheckItem(name: "창문 틀에 곰팡이 여부 확인"),
        AICheckItem(name: "화장실 누수 흔적 확인"),
        AICheckItem(name: "보일러 작동 테스트"),
        AICheckItem(name: "주변 소음 확인")
    ]

    @State private var showAddSheet = false
    @State private var newItem = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("AI가 생성한 체크리스트")
                .font(.system(size: 20, weight: .semibold))
                .padding(.top, 24)
                .padding(.bottom, 12)
                .foregroundColor(Color.customBlack)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach($checklistItems) { $item in
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
                                .foregroundColor(.black)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)

                            Spacer()
                        }
                        .padding(.vertical, 4)
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

            Button(action: onConfirm) {
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
                        checklistItems.append(AICheckItem(name: newItem))
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
    AIGeneratedListView(onConfirm: {})
}

