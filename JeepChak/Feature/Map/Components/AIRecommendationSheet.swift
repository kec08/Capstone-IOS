//
//  AIRecommendationSheet.swift
//  Eodigo
//
//  Created by 김은찬 on 12/20/25.
//

import SwiftUI

struct AIRecommendationSheet: View {
    @ObservedObject var viewModel: GoMapViewModel
    let onClose: () -> Void
    let onShowDetail: (TourSpot) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
                
                Text("AI 추천")
                    .font(.system(size: 18, weight: .bold))
                
                Spacer()
                
                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 24) {
                    // 제목
                    Text("선호하는 관광지 유형을 선택하세요")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 24)
                    
                    // 유형 버튼들
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(viewModel.tourTypes, id: \.self) { type in
                            Button(action: {
                                viewModel.toggleTourType(type)
                            }) {
                                Text(type)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(
                                        viewModel.selectedTourTypes.contains(type)
                                        ? .white
                                        : .gray
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        viewModel.selectedTourTypes.contains(type)
                                        ? Color.customBlue
                                        : Color.gray.opacity(0.1)
                                    )
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(
                                                viewModel.selectedTourTypes.contains(type)
                                                ? Color.clear
                                                : Color.gray.opacity(0.3),
                                                lineWidth: 1
                                            )
                                    )
                            }
                            .disabled(
                                !viewModel.selectedTourTypes.contains(type) && 
                                viewModel.selectedTourTypes.count >= 3
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // 선택 개수 안내
                    if viewModel.selectedTourTypes.count > 0 {
                        Text("\(viewModel.selectedTourTypes.count)/3 선택됨")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    // 추천받기 버튼
                    Button(action: {
                        Task {
                            await viewModel.recommendSpot()
                        }
                    }) {
                        Text("추천받기")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                viewModel.selectedTourTypes.isEmpty || viewModel.isRecommending
                                ? Color.gray
                                : Color.customBlue
                            )
                            .cornerRadius(12)
                    }
                    .disabled(viewModel.selectedTourTypes.isEmpty || viewModel.isRecommending)
                    .padding(.horizontal, 16)
                    
                    // 로딩 화면
                    if viewModel.isRecommending {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.2)
                                .tint(.customBlue)
                            Text("AI가 추천 장소를 분석 중입니다...")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                    
                    // AI 답변
                    if !viewModel.aiMessage.isEmpty, let spot = viewModel.recommendedSpot {
                        VStack(spacing: 20) {
                            // AI 메시지
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 24))
                                    .foregroundColor(.customBlue)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("AI")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.gray)
                                    
                                    Text(viewModel.aiMessage)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                    
                                    if !viewModel.aiRecommendationReason.isEmpty {
                                        Text(viewModel.aiRecommendationReason)
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                            .padding(.top, 4)
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                            
                            // 추천 장소 카드
                            VStack(alignment: .leading, spacing: 12) {
                                Text(spot.name)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text(spot.category)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                Text(spot.description)
                                    .font(.system(size: 14))
                                    .foregroundColor(.black.opacity(0.7))
                                    .lineLimit(3)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
                            
                            // 출발하기 버튼
                            Button(action: {
                                onClose()
                                onShowDetail(spot)
                            }) {
                                Text("출발하기")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.customBlue)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                }
            }
        }
        .background(Color.customWhite.ignoresSafeArea())
    }
}

#Preview {
    AIRecommendationSheet(
        viewModel: GoMapViewModel(),
        onClose: {},
        onShowDetail: { _ in }
    )
}

