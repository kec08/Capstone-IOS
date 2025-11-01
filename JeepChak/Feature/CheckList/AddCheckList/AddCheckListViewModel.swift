//
//  AddCheckListViewModel.swift
//  JeepChak
//
//  Created by 김은찬 on 10/20/25.
//

import SwiftUI
import Combine

final class AddCheckListViewModel: ObservableObject {
    
    enum Field: Hashable {
        case title, address, propertyType, unit, memo
    }

    // 입력 상태
    @Published var title = ""
    @Published var address = ""
    @Published var propertyType = ""
    @Published var unit = ""
    @Published var memo = ""
    @Published var selectedImage: UIImage?
    @Published var isImagePickerPresented = false
    @Published var showAILoading = false
    @Published var showAIResult = false


    
    @Published var focusedField: Field?
    
    func createCheckListItem() -> AddCheckListItem {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())

        return AddCheckListItem(
            image: selectedImage,
            title: title,
            address: address,
            propertyType: propertyType,
            unit: unit,
            memo: memo,
            date: currentDate
        )
    }

    var isValid: Bool {
        !title.isEmpty
    }
}
