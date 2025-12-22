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
    @State private var selectedFileURL: URL?
    @State private var selectedFileData: Data? // 파일 데이터를 메모리에 저장
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
                            selectedFileURL: selectedFileURL,
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
                            enabled: selectedFileData != nil && selectedProperty != nil
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
                    .pdf,
                    .image,
                    UTType(filenameExtension: "jpg")!,
                    UTType(filenameExtension: "jpeg")!,
                    UTType(filenameExtension: "png")!
                ],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    // fileImporter는 배열로 반환하므로 첫 번째 파일 사용
                    if let url = urls.first {
                        // 파일 접근 권한 획득 (fileImporter로 선택한 파일은 접근 권한이 필요함)
                        if url.startAccessingSecurityScopedResource() {
                            do {
                                // 파일 데이터를 미리 읽어서 메모리에 저장 (접근 권한이 있는 동안)
                                let fileData = try Data(contentsOf: url)
                                selectedFileURL = url
                                selectedFileData = fileData
                                print("파일 선택 성공: \(url.lastPathComponent), 크기: \(fileData.count) bytes")
                                
                                // 접근 권한 해제 (데이터를 이미 읽었으므로)
                                url.stopAccessingSecurityScopedResource()
                            } catch {
                                url.stopAccessingSecurityScopedResource()
                                print("파일 읽기 실패: \(url.lastPathComponent), 오류: \(error.localizedDescription)")
                                errorMessage = "파일을 읽을 수 없습니다: \(error.localizedDescription)"
                            }
                        } else {
                            print("파일 접근 권한 획득 실패: \(url.lastPathComponent)")
                            errorMessage = "파일 접근 권한을 획득할 수 없습니다."
                        }
                    }
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
        guard let property = selectedProperty,
              let fileURL = selectedFileURL,
              let fileData = selectedFileData else {
            errorMessage = "파일을 선택해주세요."
            return
        }
        
        // 파일 데이터가 있는지 확인
        guard !fileData.isEmpty else {
            errorMessage = "파일 데이터가 비어있습니다. 파일을 다시 선택해주세요."
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
        let tempURL = createTempFile(from: fileData, fileName: fileURL.lastPathComponent)
        
        guard let tempFileURL = tempURL else {
            errorMessage = "임시 파일을 생성할 수 없습니다."
            isLoading = false
            return
        }
        
        analyzeService.analyze(request: request, files: [tempFileURL])
            .receive(on: DispatchQueue.main)
            .sink { completion in
                // 임시 파일 삭제
                if let tempURL = tempURL {
                    try? FileManager.default.removeItem(at: tempURL)
                }
                
                isLoading = false
                if case .failure(let error) = completion {
                    errorMessage = error.localizedDescription
                    print("분석 실패: \(error.localizedDescription)")
                }
            } receiveValue: { result in
                // 임시 파일 삭제
                if let tempURL = tempURL {
                    try? FileManager.default.removeItem(at: tempURL)
                }
                
                analyzeResult = result
                resultFileURL = selectedFileURL
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

#Preview {
    AnalyzeView()
}
