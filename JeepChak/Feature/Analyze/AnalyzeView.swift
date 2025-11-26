//
//  NFTView.swift
//  Eodigo
//
//  Created by 김은찬 on 10/4/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct AnalyzeView: View {
    @State private var selectedFileURL: URL?
    @State private var selectedProperty: SavedProperty?
    
    @State private var showingFileImporter = false
    @State private var showingPropertySheet = false
    
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
                        
                        AnalyzeButton(
                            enabled: selectedFileURL != nil && selectedProperty != nil
                        ) {
                            print("분석 시작")
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, -85)
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
        }
    }
}

#Preview {
    AnalyzeView()
}
