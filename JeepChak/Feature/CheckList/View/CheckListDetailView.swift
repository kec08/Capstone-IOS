//
//  CheckListDetailView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/1/25.
//

import SwiftUI

struct CheckListDetailView: View {
    let checkItem: CheckItem
    @Binding var items: [CheckItem]
    @State private var detailItems: [DetailItem]
    @State private var showAddItemSheet = false
    @State private var newItemName = ""
    @Environment(\.dismiss) var dismiss
    
    init(checkItem: CheckItem, items: Binding<[CheckItem]>) {
        self.checkItem = checkItem
        self._items = items
        if checkItem.detailItems.isEmpty {
            self._detailItems = State(initialValue: [
                .init(name: "화장실 곰팡이 확인하기"),
                .init(name: "벽과 바닥 상태 확인하기"),
                .init(name: "창문 틈새 확인하기"),
                .init(name: "수압 확인하기"),
                .init(name: "보일러 확인하기")
            ])
        } else {
            self._detailItems = State(initialValue: checkItem.detailItems)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // 상단 헤더
            CheckListDetailHeaderView(onBackTapped: {
                dismiss()
            })
            .fixedSize(horizontal: false, vertical: true)
            
            // 타이틀
            Text("\(checkItem.title) 체크리스트")
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
            
            // 스크롤 가능한 리스트
            ScrollView {
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
                                .font(.system(size: 14))
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
                    
                    // + 버튼
                    Button(action: {
                        showAddItemSheet = true
                    }) {
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
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color.white)
            
            Spacer(minLength: 0)
            
            VStack(spacing: 0) {
                Divider()
                    .background(Color.gray.opacity(0.2))
                
                NavigationLink(destination: CheckListFinalView(
                    checkItem: checkItem,
                    detailItems: detailItems,
                    items: $items
                )) {
                    Text("확인")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 30)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: -2)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
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
}


#Preview {
    NavigationView {
        CheckListDetailView(
            checkItem: CheckItem(title: "봉양면 ㅇㅇ주택", date: "2025-09-16", imageName: "CheckListHouse1", image: nil),
            items: .constant([])
        )
    }
}
