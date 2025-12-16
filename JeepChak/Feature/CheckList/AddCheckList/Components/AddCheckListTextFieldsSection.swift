//
//  AddCheckListTextFieldsSection.swift
//  JeepChak
//
//  Created by 김은찬 on 12/16/25.
//

import SwiftUI

struct AddCheckListTextFieldsSection: View {
    @ObservedObject var viewModel: AddCheckListViewModel
    @Binding var focusedField: AddCheckListViewModel.Field?

    var body: some View {
        VStack(spacing: 20) {

            CheckListTextField(label: "매물 이름",
                               text: $viewModel.name,
                               isFocused: focusedField == .name)
                .focused($focusedField, equals: .name)

            CheckListTextField(label: "주소",
                               text: $viewModel.address,
                               isFocused: focusedField == .address)
                .focused($focusedField, equals: .address)

            AddCheckListPropertyTypeDropdown(
                selected: $viewModel.propertyType
            )

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

            AddCheckListRentTypeSection(
                leaseType: $viewModel.leaseType,
                deposit: $viewModel.deposit,
                monthlyRent: $viewModel.monthlyRent,
                focusedField: $focusedField
            )

            if !viewModel.displayPriceText.isEmpty {
                HStack {
                    Text("표시 가격: ")
                        .foregroundColor(.gray)
                    Text(viewModel.displayPriceText)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .font(.system(size: 14))
            }
        }
    }
}
