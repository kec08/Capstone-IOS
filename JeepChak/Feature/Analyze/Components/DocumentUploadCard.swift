//
//  DocumentUploadCard.swift
//  JeepChak
//
//  Created by 김은찬 on 11/26/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentUploadCard: View {
    let selectedFileURL: URL?
    @Binding var showingFileImporter: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                showingFileImporter = true
            } label: {
                VStack(spacing: 16) {
                    if let file = selectedFileURL {
                        Image("Analyz_documents")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                        
                        Text(file.lastPathComponent)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.blue)
                        
                    } else {
                        Image("Analyz_upload")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                            .foregroundColor(.customBlue)
                        
                        Text("등기 부동본, 건축물대장")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.customBlack)
                        
                        Text("PNG,JPG,PDF 업로드")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        Text("파일 업로드")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
                .frame(maxWidth: 350, minHeight: 210)
                .background(Color.customWhite)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    DocumentUploadCard(selectedFileURL: nil, showingFileImporter: .constant(false))
}
