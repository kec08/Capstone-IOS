//
//  MyViewModel.swift
//  Eodigo
//
//  Created by 김은찬 on 10/4/25.
//

import SwiftUI
import Combine

final class MyViewModel: ObservableObject {
    @Published var userInfo: UserInfo
    @Published var showSettings: Bool = false

    init() {
        userInfo = UserInfo(
            name: "김은찬",
            email: "Kkk1234@naver.com",
            phone: "010-1234-5678",
            userId: "kimeunchan"
        )
    }

    func openSettings() {
        showSettings = true
    }
}
