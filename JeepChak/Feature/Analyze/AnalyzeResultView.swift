//
//  AnalyzeResultView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/27/25.
//

import SwiftUI
import Foundation

struct AnalyzeResultView: View {
    @Environment(\.dismiss) private var dismiss
    
    let score: Int
    let summary: String
    let details: [RiskDetail]
    let property: SavedProperty?
    let analyzeResult: AnalyzeResponseDTO?
    let tempFileURLs: [URL]
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.customBlack)
                }
                
                Spacer()
                
                Text("매물 분석 결과")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.customBlack)
                
                Spacer()
                
                // 오른쪽 여백용
                Spacer().frame(width: 24)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            
            ScrollView {
                // %
                VStack(spacing: 8) {
                    Text("위험도")
                        .font(.system(size: 15))
                        .foregroundColor(.customDarkGray)
                    
                    Text("\(score)%")
                        .font(.system(size: 46, weight: .bold))
                        .foregroundColor(.customYellow)
                }
                .padding(.vertical, 45)
                
                // AI 분석 요약
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 6) {
                        Image("AI_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22)
                            .padding(.bottom, 6)
                        Text("AI 분석 요약")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.customBlack)
                            .padding(.bottom, 4)
                    }
                    
                    Text(summary)
                        .font(.system(size: 14))
                        .foregroundColor(.customBlack)
                        .lineSpacing(7)
                        .padding(.bottom, 26)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("상세 분석 결과")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.customBlack)
                        .padding(.top, 16)
                        .padding(.leading, 16)
                    
                    VStack(spacing: 10) {
                        ForEach(details) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(item.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.customBlack)
                                    .padding(.bottom, 4)
                                    .lineSpacing(5)
                                
                                Text(item.description)
                                    .font(.system(size: 13))
                                    .foregroundColor(.customDarkGray)
                                    .lineSpacing(4)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.customWhite)
                            .cornerRadius(12)
                        }
                    }
                    .padding(14)
                    .padding(.top, -5)
                }
                .background(Color(white: 0.97))
                .cornerRadius(10)
                .padding(.trailing, 4)
                .padding(.bottom, 20)
                
                // 하단 버튼(스크롤 콘텐츠에 포함)
                Button {
                    dismiss()
                } label: {
                    Text("확인")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .foregroundColor(.customWhite)
                        .background(Color.customBlue)
                        .cornerRadius(12)
                }
                .padding(.top, 18)
                // 탭바에 가리지 않도록 충분한 하단 여백
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 22)
        }
        .background(Color.customBackgroundGray)
        .navigationBarHidden(true)
        .onDisappear {
            cleanupTempFiles()
        }
    }
    
    private func cleanupTempFiles() {
        guard !tempFileURLs.isEmpty else { return }
        for url in tempFileURLs {
            try? FileManager.default.removeItem(at: url)
        }
    }
}
