//
//  AnalyzeResultView.swift
//  JeepChak
//
//  Created by 김은찬 on 11/27/25.
//

import SwiftUI
import Combine
import Foundation

struct AnalyzeResultView: View {
    @Environment(\.dismiss) private var dismiss
    
    // 나중에 AI 결과로 채워 넣을 값들
    let score: Int
    let summary: String
    let details: [RiskDetail]
    let property: SavedProperty?
    let analyzeResult: AnalyzeResponseDTO?
    /// `AnalyzeLoadingView`가 만든 임시 파일 URL들 (결과 화면 이탈 시 정리)
    let tempFileURLs: [URL]
    
    @State private var showingRiskSolution = false
    @State private var riskSolutionData: RiskSolutionResponseDTO?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private let analyzeService = AnalyzeService()
    @State private var cancellables = Set<AnyCancellable>()
    
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
            .padding(.top, 25)
            
            VStack(spacing: 24) {
                ScrollView{
                    // 점수
                    VStack(spacing: 8) {
                        Text("위험점수")
                            .font(.system(size: 15))
                            .foregroundColor(.customDarkGray)
                        
                        Text("\(score)점")
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
                    .padding(.bottom, 45)
                }
                .padding(.horizontal, 22)
            }
                
            
            Spacer()
            
            // 하단 버튼
            Button {
                loadRiskSolution()
            } label: {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("대처 방안 확인하기")
                        .font(.system(size: 17, weight: .semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .foregroundColor(.customWhite)
            .background(Color.customBlue)
            .cornerRadius(12)
            .disabled(isLoading)
            .padding(.horizontal, 22)
            .padding(.top, 10)
            .sheet(isPresented: $showingRiskSolution) {
                if let solutionData = riskSolutionData {
                    NavigationView {
                        RiskSolutionView(solutionData: solutionData)
                    }
                }
            }
            .alert("오류", isPresented: .constant(errorMessage != nil)) {
                Button("확인") {
                    errorMessage = nil
                }
            } message: {
                if let error = errorMessage {
                    Text(error)
                }
            }
        }
        .background(Color.customBackgroundGray)
        .navigationBarHidden(true)
        .onDisappear {
            cleanupTempFiles()
        }
    }
    
    private func loadRiskSolution() {
        guard let property = property else { return }
        
        let marketPrice = property.deposit ?? 0
        let deposit = property.deposit ?? 0
        let monthlyRent = property.monthlyRent ?? 0
        
        let request = RiskSolutionRequestDTO(
            propertyId: property.propertyId,
            marketPrice: marketPrice,
            deposit: deposit,
            monthlyRent: monthlyRent
        )
        
        isLoading = true
        errorMessage = nil
        
        // 파일 전달
        analyzeService.riskSolution(request: request, files: tempFileURLs)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                isLoading = false
                if case .failure(let error) = completion {
                    errorMessage = error.localizedDescription
                    print("대처 방안 로드 실패: \(error.localizedDescription)")
                }
            } receiveValue: { solution in
                riskSolutionData = solution
                showingRiskSolution = true
            }
            .store(in: &cancellables)
    }
    
    private func cleanupTempFiles() {
        guard !tempFileURLs.isEmpty else { return }
        for url in tempFileURLs {
            try? FileManager.default.removeItem(at: url)
        }
    }
}

// MARK: - mock 데이터

extension AnalyzeResultView {
    static var mock: AnalyzeResultView {
        let mockDetails = [
            AnalyzeDetailItem(
                original: "근저당권 설정: 채권최고액 240,000,000원, 채권자 ○○은행",
                analysisText: "이 문구는 소유 부동산에 금융기관의 담보권이 걸려 있음을 의미합니다. 매수 전 반드시 말소 여부를 확인해야 합니다."
            ),
            AnalyzeDetailItem(
                original: "가압류: ○○지방법원, 채권액 35,000,000원",
                analysisText: "해당 부동산이 채권자의 임시적 압류 조치 대상입니다. 매수 시 인수 위험이 있으므로 주의가 필요합니다."
            ),
            AnalyzeDetailItem(
                original: "대지권 미등기",
                analysisText: "아파트·오피스텔 등에서 대지권이 없으면 소유권 보호가 제한되므로 매우 위험합니다."
            )
        ]
        
        let mockResult = AnalyzeResponseDTO(
            totalRisk: 65,
            details: mockDetails,
            comment: "이 매물은 높은 위험도로 분류됩니다. 가압류가 설정되어 있고, 근저당권이 시세의 70%를 초과하며, 전세보증금 비율이 매우 높아 깡통 전세 위험이 있습니다. 최근 1년간 소유권이 3회 이상 이전된 것도 주의가 필요합니다. 계약을 진행하신다면 반드시 전세보증보험 가입과 법률 검토가 필요합니다."
        )
        
        return AnalyzeResultView(
            score: 65,
            summary: mockResult.comment,
            details: mockResult.details.map { RiskDetail(title: $0.original, description: $0.analysisText) },
            property: nil,
            analyzeResult: mockResult,
            tempFileURLs: []
        )
    }
}


struct AnalyzeResultView_Previews: PreviewProvider {
    static var previews: some View {
            NavigationView {
                AnalyzeResultView.mock
            }
    }
}
