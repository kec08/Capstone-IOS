import SwiftUI
import Combine

struct AddCheckListView: View {
    @StateObject private var viewModel = AddCheckListViewModel()
    @FocusState private var focusedField: AddCheckListViewModel.Field?

    var addCheckListItem: (AddCheckListItem) -> Void
    var onDismiss: () -> Void
    var propertyId: Int = 1

    var body: some View {
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
                Text("매물추가")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.customBlack)
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
        .onTapGesture { viewModel.isImagePickerPresented = true }
        .sheet(isPresented: $viewModel.isImagePickerPresented) {
            ImagePicker(
                image: $viewModel.selectedImage,
                isPresented: $viewModel.isImagePickerPresented
            )
        }
    }

    // MARK: - 텍스트 입력 섹션
    private var textFieldsSection: some View {
        VStack(spacing: 20) {

            CheckListTextField(label: "매물 이름",
                               text: $viewModel.name,
                               isFocused: focusedField == .name)
                .focused($focusedField, equals: .name)

            CheckListTextField(label: "주소",
                               text: $viewModel.address,
                               isFocused: focusedField == .address)
                .focused($focusedField, equals: .address)

            // 주택 형태
            propertyTypeDropdown

            CheckListTextField(label: "층수",
                               text: $viewModel.floor,
                               isFocused: focusedField == .floor)
                .focused($focusedField, equals: .floor)
                .keyboardType(.numberPad)

            CheckListTextField(label: "평수",
                               text: $viewModel.area,
                               isFocused: focusedField == .area)
                .focused($focusedField, equals: .area)
                .keyboardType(.numberPad)

            CheckListTextField(label: "준공년도",
                               text: $viewModel.builtYear,
                               isFocused: focusedField == .builtYear)
                .focused($focusedField, equals: .builtYear)
                .keyboardType(.numberPad)

            CheckListTextField(label: "시세",
                               text: $viewModel.marketPrice,
                               isFocused: focusedField == .marketPrice)
                .focused($focusedField, equals: .marketPrice)
                .keyboardType(.numberPad)

            rentTypeSection

            if !viewModel.displayPriceText.isEmpty {
                HStack {
                    Text("표시 가격: ")
                        .foregroundColor(.gray)
                    Text(viewModel.displayPriceText)
                        .foregroundColor(.customBlack)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .font(.system(size: 14))
            }
        }
    }

    private var propertyTypeDropdown: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("주택 형태")
                .foregroundColor(.gray)
                .font(.system(size: 14))

            Menu {
                ForEach(PropertyType.allCases) { type in
                    Button {
                        viewModel.propertyType = type
                    } label: {
                        Text(type.displayName)
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.propertyType.displayName)
                        .foregroundColor(.customBlack)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .foregroundColor(.customGray300)
                }
                .padding()
                .background(Color.customWhite)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.customGray100, lineWidth: 1)
                )
            }
        }
        .padding(.vertical, 20)
    }

    // MARK: - 메모 입력
    private var memoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("메모")
                .foregroundColor(.gray)
                .font(.system(size: 14))

            TextEditor(text: $viewModel.memo)
                .scrollContentBackground(.hidden)
                .background(Color.customWhite)
                .font(.system(size: 16))
                .foregroundColor(.customBlack)
                .frame(height: 120)
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .focused($focusedField, equals: .memo)
        }
    }

    // MARK: - 버튼 섹션
    private var actionButtons: some View {
        HStack(spacing: 10) {

            Button("뒤로가기") { onDismiss() }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.customGray100)
                .cornerRadius(8)
                .foregroundColor(.gray)
                .fontWeight(.semibold)

            Button("추가하기") {
                guard viewModel.isValid else { return }

                viewModel.submitCreateProperty {
                    // 확인 누르면 닫히게 설정
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.customBlue)
            .cornerRadius(8)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .fontWeight(.semibold)
            .disabled(viewModel.isSubmitting)
            .opacity(viewModel.isSubmitting ? 0.6 : 1.0)

            // 완료 메시지
            .sheet(isPresented: $viewModel.showMessageSheet) {
                MessageCompleteView(message: viewModel.serverMessage) {
                    viewModel.showMessageSheet = false
                    onDismiss()
                }
            }
        }
        .padding(.top, 20)
    }
}

extension AddCheckListView {

    private var rentTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("거래 유형")
                .foregroundColor(.gray)
                .font(.system(size: 14))
                .padding(.top, 10)

            HStack(spacing: 12) {
                rentTypeButton(type: .monthly, title: "월세")
                rentTypeButton(type: .jeonse, title: "전세")
            }
            .padding(.bottom, 12)

            CheckListTextField(
                label: viewModel.leaseType == .jeonse ? "전세금" : "보증금",
                text: $viewModel.deposit,
                isFocused: focusedField == .deposit
            )
            .focused($focusedField, equals: .deposit)
            .keyboardType(.numberPad)

            if viewModel.leaseType == .monthly {
                CheckListTextField(
                    label: "월세 금액",
                    text: $viewModel.monthlyRent,
                    isFocused: focusedField == .monthlyRent
                )
                .focused($focusedField, equals: .monthlyRent)
                .keyboardType(.numberPad)
            }
        }
        .onChange(of: viewModel.leaseType) { newValue in
            if newValue == .jeonse {
                viewModel.monthlyRent = ""
            }
        }
    }

    private func rentTypeButton(type: LeaseType, title: String) -> some View {
        Button {
            viewModel.leaseType = type
        } label: {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(viewModel.leaseType == type ? .customWhite : .customBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    viewModel.leaseType == type
                    ? Color.customBlue
                    : Color.customBlue.opacity(0.1)
                )
                .cornerRadius(8)
        }
    }
}


struct AddCheckListView_Previews: PreviewProvider {
    static var previews: some View {
            AddCheckListView(
                addCheckListItem: { _ in print("체크리스트 아이템이 추가되었습니다.") },
                onDismiss: { print("뷰가 닫혔습니다.") }
            )
    }
}
