//
//  NFTView.swift
//  Eodigo
//
//  Created by 김은찬 on 10/4/25.
//

import SwiftUI
import UniformTypeIdentifiers
import Combine
import Foundation

struct AnalyzeView: View {
    @State private var selectedFileURLs: [URL] = []
    @State private var selectedFileDatas: [Data] = [] // 파일 데이터를 메모리에 저장
    @State private var selectedProperty: SavedProperty?
    
    @State private var showingFileImporter = false
    @State private var showingPropertySheet = false
    @State private var showingResult = false
    @State private var analyzeResult: AnalyzeResponseDTO?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var resultFileURL: URL?
    
    private let analyzeService = AnalyzeService()
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationView {
            VStack {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        AnalyzeHeaderView()
                        
                        DocumentUploadCard(
                            selectedFileURLs: selectedFileURLs,
                            showingFileImporter: $showingFileImporter
                        )
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 20)
                        
                        PropertyUploadCard(
                            selectedProperty: selectedProperty,
                            showingSheet: $showingPropertySheet
                        )
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 20)
                    }
                        
                    VStack {
                        Spacer()
                        AnalyzeButton(
                            enabled: !selectedFileDatas.isEmpty && selectedProperty != nil
                        ) {
                            startAnalysis()
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                }
            }
            .background(.customBackgroundGray)
            .navigationBarHidden(true)
            .fileImporter(
                isPresented: $showingFileImporter,
                allowedContentTypes: [
                    .pdf
                ],
                allowsMultipleSelection: true
            ) { result in
                switch result {
                case .success(let urls):
                    // 여러 파일 처리
                    var pickedURLs: [URL] = []
                    var pickedDatas: [Data] = []

                    // ✅ 최대 2개까지만 허용
                    for url in urls.prefix(2) {
                        if url.startAccessingSecurityScopedResource() {
                            defer { url.stopAccessingSecurityScopedResource() }
                            do {
                                let fileData = try Data(contentsOf: url)
                                guard !fileData.isEmpty else { continue }
                                pickedURLs.append(url)
                                pickedDatas.append(fileData)
                                print("파일 선택 성공: \(url.lastPathComponent), 크기: \(fileData.count) bytes")
                            } catch {
                                print("파일 읽기 실패: \(url.lastPathComponent), 오류: \(error.localizedDescription)")
                                errorMessage = "파일을 읽을 수 없습니다: \(error.localizedDescription)"
                                return
                            }
                        } else {
                            print("파일 접근 권한 획득 실패: \(url.lastPathComponent)")
                            errorMessage = "파일 접근 권한을 획득할 수 없습니다."
                            return
                        }
                    }

                    selectedFileURLs = pickedURLs
                    selectedFileDatas = pickedDatas
                case .failure(let error):
                    print("파일 선택 실패: \(error.localizedDescription)")
                    errorMessage = "파일을 선택할 수 없습니다: \(error.localizedDescription)"
                }
            }
            .sheet(isPresented: $showingPropertySheet) {
                PropertyUploadView { saved in
                    self.selectedProperty = saved
                }
            }
            .sheet(isPresented: $showingResult) {
                if let result = analyzeResult {
                    NavigationView {
                        AnalyzeResultView(
                            score: result.totalRisk,
                            summary: result.comment,
                            details: result.details.map { RiskDetail(title: $0.original, description: $0.analysisText) },
                            property: selectedProperty,
                            analyzeResult: result,
                            fileURL: resultFileURL
                        )
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
    }
    
    private func startAnalysis() {
        guard let property = selectedProperty else {
            errorMessage = "매물을 선택해주세요."
            return
        }

        // ✅ 파일은 1~2개 허용
        guard selectedFileDatas.count >= 1, selectedFileURLs.count >= 1 else {
            errorMessage = "PDF 파일을 1~2개 업로드해주세요."
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
        
        isLoading = true
        errorMessage = nil
        
        // 파일 데이터를 임시 파일로 저장하여 URL 생성
        var tempFileURLs: [URL] = []
        for (idx, data) in selectedFileDatas.enumerated() {
            let originalName = selectedFileURLs.indices.contains(idx) ? selectedFileURLs[idx].lastPathComponent : "document_\(idx).pdf"
            if let tempURL = createTempFile(from: data, fileName: originalName) {
                tempFileURLs.append(tempURL)
            }
        }

        guard tempFileURLs.count >= 1 else {
            errorMessage = "임시 파일을 생성할 수 없습니다."
            isLoading = false
            return
        }

        analyzeService.analyze(request: request, files: tempFileURLs)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                // 임시 파일 삭제
                for url in tempFileURLs {
                    try? FileManager.default.removeItem(at: url)
                }
                
                isLoading = false
                if case .failure(let error) = completion {
                    errorMessage = error.localizedDescription
                    print("분석 실패: \(error.localizedDescription)")
                }
            } receiveValue: { result in
                // 임시 파일 삭제
                for url in tempFileURLs {
                    try? FileManager.default.removeItem(at: url)
                }
                
                analyzeResult = result
                resultFileURL = selectedFileURLs.first
                showingResult = true
            }
            .store(in: &cancellables)
    }
    
    // 파일 데이터를 임시 파일로 저장하는 헬퍼 함수
    private func createTempFile(from data: Data, fileName: String) -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let tempFileURL = tempDir.appendingPathComponent(fileName)
        
        do {
            try data.write(to: tempFileURL)
            print("임시 파일 생성 성공: \(tempFileURL.path)")
            return tempFileURL
        } catch {
            print("임시 파일 생성 실패: \(error.localizedDescription)")
            return nil
        }
    }
}


struct AnalyzeView_Previews: PreviewProvider {
    static var previews: some View {
            AnalyzeView()
    }
}
