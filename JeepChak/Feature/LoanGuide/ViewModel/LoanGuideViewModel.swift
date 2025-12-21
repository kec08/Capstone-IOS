//
//  LoanGuideViewModel.swift
//  JeepChak
//
//  Created by 김은찬 on 12/21/25.
//

import Foundation
import SwiftUI
import Combine

class LoanGuideViewModel: ObservableObject {
    static let shared = LoanGuideViewModel()
    
    @Published var data: LoanGuideData = LoanGuideData()
    
    private init() {
        loadData()
    }
    
    // UserDefaults에 저장
    func saveData() {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: "LoanGuideData")
        }
    }
    
    // UserDefaults에서 불러오기
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "LoanGuideData"),
           let decoded = try? JSONDecoder().decode(LoanGuideData.self, from: data) {
            self.data = decoded
        }
    }
    
    // 데이터 초기화
    func resetData() {
        data = LoanGuideData()
        UserDefaults.standard.removeObject(forKey: "LoanGuideData")
    }
}

