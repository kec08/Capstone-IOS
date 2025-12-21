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
                            enabled: selectedFileURL != nil && selectedProperty != nil
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
                ]
            ) { result in
                switch result {
                case .success(let url):
                    selectedFileURL = url
                case .failure:
                    break
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
              let fileURL = selectedFileURL else {
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
        
        analyzeService.analyze(request: request, files: [fileURL])
            .receive(on: DispatchQueue.main)
            .sink { completion in
                isLoading = false
                if case .failure(let error) = completion {
                    errorMessage = error.localizedDescription
                    print("분석 실패: \(error.localizedDescription)")
                }
            } receiveValue: { result in
                analyzeResult = result
                resultFileURL = selectedFileURL
                showingResult = true
            }
            .store(in: &cancellables)
    }
}

#Preview {
    AnalyzeView()
}
