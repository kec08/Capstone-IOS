//
//  CheckListFinalViewModel.swift
//  JeepChak
//
//  Created by 김은찬 on 11/2/25.
//

import Foundation
import SwiftUI
import Combine

final class CheckListFinalViewModel: ObservableObject {
    @Published var showAIReport: Bool = false

    init() { }

    func openAIReport() {
        showAIReport = true
    }

    func closeAIReport() {
        showAIReport = false
    }
}
