//
//  AddCheckListView.swift
//  JeepChak
//
//  Created by 김은찬 on 10/20/25.
//

import SwiftUI

struct AddCheckListView: View {
    @StateObject private var viewModel = AddCheckListViewModel()
    @FocusState private var focusedField: AddCheckListViewModel.Field?

    var addCheckListItem: (AddCheckListItem) -> Void
    var onDismiss: () -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    imagePickerSection
                    textFieldsSection
                    memoSection
                    actionButtons
                }
                .padding(.horizontal, 40)
                .padding(.vertical)
                .background(Color.white)
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("체크리스트")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
    }

    // MARK: - 섹션
    private var imagePickerSection: some View {
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
        .onTapGesture {
            viewModel.isImagePickerPresented = true
        }
        .sheet(isPresented: $viewModel.isImagePickerPresented) {
            ImagePicker(image: $viewModel.selectedImage, isPresented: $viewModel.isImagePickerPresented)
        }
    }

    private var textFieldsSection: some View {
        VStack(spacing: 20) {
            CheckListTextField(label: "매물 이름", text: $viewModel.title, isFocused: focusedField == .title)
                .focused($focusedField, equals: .title)

            CheckListTextField(label: "주소", text: $viewModel.address, isFocused: focusedField == .address)
                .focused($focusedField, equals: .address)

            CheckListTextField(label: "주택 형태", text: $viewModel.propertyType, isFocused: focusedField == .propertyType)
                .focused($focusedField, equals: .propertyType)

            CheckListTextField(label: "동/호수", text: $viewModel.unit, isFocused: focusedField == .unit)
                .focused($focusedField, equals: .unit)
        }
    }

    private var memoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("메모")
                .foregroundColor(.gray)
                .font(.system(size: 14))
            TextEditor(text: $viewModel.memo)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .frame(height: 120)
                .padding(12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .focused($focusedField, equals: .memo)
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 10) {
            Button("뒤로가기") {
                onDismiss()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .foregroundColor(.gray)
            .fontWeight(.medium)

            Button("추가하기") {
                guard viewModel.isValid else { return }
                let newItem = viewModel.createCheckListItem()
                addCheckListItem(newItem)
                viewModel.showAILoading = true
            }
            .sheet(isPresented: $viewModel.showAILoading) {
                AILoadingView {
                    viewModel.showAILoading = false
                    viewModel.showAIResult = true
                }
            }
            .sheet(isPresented: $viewModel.showAIResult) {
                AIGeneratedListView(onConfirm: {
                    onDismiss()
                })
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.cyan)
            .foregroundColor(.white)
            .cornerRadius(8)
            .fontWeight(.medium)
        }
        .padding(.top, 20)
    }
}
