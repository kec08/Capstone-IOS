//
//  CheckListFinalView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/2/25.
//

import SwiftUI

struct CheckListFinalView: View {
    let title: String
    var items: [DetailItem]
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
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(items) { item in
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.name)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    if !item.memo.isEmpty {
                                        Text(item.memo)
                                            .font(.system(size: 14))
                                            .foregroundColor(.cyan)
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
            .background(Color.white)
            
            // AI 분석 버튼 (오른쪽 하단)
            Button(action: {
                showAIReport = true
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 54, height: 54)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 4, y: 4)
                    
                    Image("AI_icon")
                        .resizable()
                        .frame(width: 29, height: 32)
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 30)
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showAIReport) {
            AIResultView()
        }
    }
}
