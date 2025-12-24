//
//  DocumentUploadCard.swift
//  JeepChak
//
//  Created by 김은찬 on 11/26/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentUploadCard: View {
    let selectedFileURLs: [URL]
    @Binding var showingFileImporter: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                showingFileImporter = true
            } label: {
                VStack(spacing: 16) {
                    if !selectedFileURLs.isEmpty {
                        Image("Analyz_documents")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 85, height: 80)
                            .foregroundColor(.customBlue)
                            .padding(.top, -10)
                        
                        Text("업로드된 파일 \(selectedFileURLs.count)개")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.customBlue)

                        // 최대 2개 파일명 표시
                        ForEach(Array(selectedFileURLs.prefix(2)).indices, id: \.self) { idx in
                            Text(selectedFileURLs[idx].lastPathComponent)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.customDarkGray)
                                .lineLimit(1)
                        }
                        
                    } else {
                        Image("Analyz_upload")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                            .foregroundColor(.customBlue)
                        
                        Text("등기 부동본, 건축물대장")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.customBlack)
                        
                        Text("PDF 1~2개 업로드")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        Text("파일 업로드")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.customBlue)
                    }
                }
                .frame(maxWidth: 350, minHeight: 210)
                .background(Color.customWhite)
                .cornerRadius(18)
                .shadow(color: Color.customBlack.opacity(0.06), radius: 12, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
    }
}


struct DocumentUploadCard_Previews: PreviewProvider {
    static var previews: some View {
            DocumentUploadCard(selectedFileURLs: [], showingFileImporter: .constant(false))
    }
}
