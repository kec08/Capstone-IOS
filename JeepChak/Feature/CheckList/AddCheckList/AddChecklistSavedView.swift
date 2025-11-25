//
//  AddChecklistSavedView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/15/25.
//

import SwiftUI

struct AddChecklistFromWishlistView: View {
    @StateObject private var viewModel = SavedViewModel()
    @State private var selectedProperties: Set<Int> = []
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text("체크리스트 추가")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    // 직접 추가
                }) {
                    Text("직접 추가")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            // 타이틀
            Text("체크리스트 추가하기")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            // 매물 목록
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.properties) { property in
                        SelectablePropertyCard(
                            property: property,
                            isSelected: selectedProperties.contains(property.id),
                            onSelect: {
                                if selectedProperties.contains(property.id) {
                                    selectedProperties.remove(property.id)
                                } else {
                                    selectedProperties.insert(property.id)
                                }
                            }
                        )
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 20)
                .padding(.bottom, 100)
            }
            
            Spacer()
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .overlay(
            // 하단 고정 버튼
            VStack {
                Spacer()
                Button(action: {
                    // 추가하기
                }) {
                    Text("추가하기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedProperties.isEmpty ? Color.gray.opacity(0.3) : Color.cyan)
                        .cornerRadius(12)
                }
                .disabled(selectedProperties.isEmpty)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                .background(
                    Color.white
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                )
            }
        )
    }
}
