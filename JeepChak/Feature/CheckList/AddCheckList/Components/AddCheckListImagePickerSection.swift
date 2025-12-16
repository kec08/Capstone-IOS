//
//  AddCheckListImagePickerSection.swift
//  JeepChak
//
//  Created by 김은찬 on 12/16/25.
//

import SwiftUI

struct AddCheckListImagePickerSection: View {
    @ObservedObject var viewModel: AddCheckListViewModel

    var body: some View {
        ZStack {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 240)
                    .clipped()
                    .cornerRadius(10)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.cyan)
                    Text("방 사진을 추가해보세요")
                        .foregroundColor(.cyan)
                        .font(.system(size: 16, weight: .medium))
                }
                .frame(height: 240)
                .frame(maxWidth: .infinity)
                .background(Color.cyan.opacity(0.05))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.cyan.opacity(0.3), lineWidth: 2)
                )
            }
        }
        .padding(.top, -10)
        .padding(.bottom, 20)
        .onTapGesture { viewModel.isImagePickerPresented = true }
        .sheet(isPresented: $viewModel.isImagePickerPresented) {
            ImagePicker(
                image: $viewModel.selectedImage,
                isPresented: $viewModel.isImagePickerPresented
            )
        }
    }
}
