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
    @State private var errorMessage: String?
    
    @State private var navigateToLoading = false
    @State private var loadingProperty: SavedProperty?
    @State private var loadingFileURLs: [URL] = []
    @State private var loadingFileDatas: [Data] = []
    
    var body: some View {
        NavigationStack {
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
                            goToAnalyzeLoading()
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                }
            }
            .background(.customBackgroundGray)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToLoading) {
                if let property = loadingProperty {
                    AnalyzeLoadingView(
                        property: property,
                        selectedFileURLs: loadingFileURLs,
                        selectedFileDatas: loadingFileDatas
                    )
                }
            }
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
    
    private func goToAnalyzeLoading() {
        guard let property = selectedProperty else {
            errorMessage = "매물을 선택해주세요."
            return
        }

        // ✅ 파일은 1~2개 허용
        guard selectedFileDatas.count >= 1, selectedFileURLs.count >= 1 else {
            errorMessage = "PDF 파일을 1~2개 업로드해주세요."
            return
        }
        
        errorMessage = nil
        
        loadingProperty = property
        loadingFileURLs = selectedFileURLs
        loadingFileDatas = selectedFileDatas
        navigateToLoading = true
    }
}


struct AnalyzeView_Previews: PreviewProvider {
    static var previews: some View {
            AnalyzeView()
    }
}
