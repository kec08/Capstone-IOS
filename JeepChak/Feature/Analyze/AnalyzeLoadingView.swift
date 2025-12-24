//
//  AnalyzeLoadingView.swift
//  JeepChak
//
//  Created by GPT on 12/24/25.
//

import SwiftUI
import Combine
import Foundation

struct AnalyzeLoadingView: View {
    @Environment(\.dismiss) private var dismiss
    
    let property: SavedProperty
    let selectedFileURLs: [URL]
    let selectedFileDatas: [Data]
    
    @State private var hasRequested = false
    @State private var navigateToResult = false
    
    @State private var analyzeResult: AnalyzeResponseDTO?
    @State private var tempFileURLs: [URL] = []
    
    @State private var showErrorAlert = false
    @State private var errorMessage: String?
    
    private let analyzeService = AnalyzeService()
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // 시간 기반 회전(연속)으로 루프 경계 스냅/끊김 제거
                TimelineView(.animation) { timeline in
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    let period: TimeInterval = 1.5
                    let progress = (t.truncatingRemainder(dividingBy: period)) / period
                    let angle = progress * 360.0
                    
                    Image("AI_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 105, height: 105)
                        .rotationEffect(.degrees(angle))
                }
                
                Text("AI가 최적의 매물분석 결과를\n생성하는 중입니다…")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.customDarkGray)
                    .lineLimit(15)
                    .padding(.top, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToResult) {
                if let result = analyzeResult {
                    AnalyzeResultView(
                        score: result.totalRisk,
                        summary: result.comment,
                        details: result.details.map {
                            RiskDetail(title: $0.original, description: $0.analysisText)
                        },
                        property: property,
                        analyzeResult: result,
                        tempFileURLs: tempFileURLs
                    )
                }
            }
            .onAppear {
                if !hasRequested {
                    hasRequested = true
                    requestAnalyze()
                }
            }
            .alert("매물 분석 실패", isPresented: $showErrorAlert) {
                Button("닫기", role: .cancel) {
                    cleanupTempFiles()
                    dismiss()
                }
                Button("다시 시도") {
                    cleanupTempFiles()
                    requestAnalyze()
                }
            } message: {
                Text(errorMessage ?? "알 수 없는 오류가 발생했습니다.")
            }
        }
    }
    
    private func requestAnalyze() {
        errorMessage = nil
        showErrorAlert = false
        analyzeResult = nil
        tempFileURLs = []
        
        // ✅ 파일은 1~2개 허용
        guard !selectedFileDatas.isEmpty else {
            errorMessage = "PDF 파일을 1~2개 업로드해주세요."
            showErrorAlert = true
            return
        }
        
        // marketPrice가 없으면 deposit을 사용하거나 기본값 사용
        let marketPrice = property.deposit ?? 0
        let deposit = property.deposit ?? 0
        let monthlyRent = property.monthlyRent ?? 0
        
        let request = AnalyzeRequestDTO(
            propertyId: property.propertyId,
            marketPrice: marketPrice,
            deposit: deposit,
            monthlyRent: monthlyRent
        )
        
        // 파일 데이터를 임시 파일로 저장하여 URL 생성 (보안 스코프 이슈 회피)
        var createdTempURLs: [URL] = []
        for (idx, data) in selectedFileDatas.enumerated() {
            let originalName = selectedFileURLs.indices.contains(idx)
            ? selectedFileURLs[idx].lastPathComponent
            : "document_\(idx).pdf"
            
            if let tempURL = createTempFile(from: data, fileName: originalName) {
                createdTempURLs.append(tempURL)
            }
        }
        
        guard !createdTempURLs.isEmpty else {
            errorMessage = "임시 파일을 생성할 수 없습니다."
            showErrorAlert = true
            return
        }
        
        tempFileURLs = createdTempURLs
        
        analyzeService.analyze(request: request, files: createdTempURLs)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                }
            } receiveValue: { result in
                analyzeResult = result
                navigateToResult = true
            }
            .store(in: &cancellables)
    }
    
    private func createTempFile(from data: Data, fileName: String) -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let uniqueName = "\(UUID().uuidString)_\(fileName)"
        let tempFileURL = tempDir.appendingPathComponent(uniqueName)
        
        do {
            try data.write(to: tempFileURL)
            return tempFileURL
        } catch {
            return nil
        }
    }
    
    private func cleanupTempFiles() {
        for url in tempFileURLs {
            try? FileManager.default.removeItem(at: url)
        }
        tempFileURLs = []
    }
}


