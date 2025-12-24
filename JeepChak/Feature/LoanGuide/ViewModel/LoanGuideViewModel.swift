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
    @Published var loanResult: LoanGuideResponseDTO? = nil
    @Published var isRequestingLoan: Bool = false
    @Published var loanErrorMessage: String? = nil
    @Published var showLoanErrorAlert: Bool = false
    
    private let loanService = LoanService()
    private var cancellables = Set<AnyCancellable>()
    
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
        loanResult = nil
        UserDefaults.standard.removeObject(forKey: "LoanGuideData")
    }

    /// 설문 데이터 기반으로 대출 가이드 생성 API 호출 (POST /api/loan)
    func requestLoanGuide() {
        guard !isRequestingLoan else { return }
        isRequestingLoan = true
        loanErrorMessage = nil
        showLoanErrorAlert = false

        let request = LoanGuideRequestDTO.from(data)

        loanService.createLoanGuide(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isRequestingLoan = false
                if case .failure(let err) = completion {
                    self.loanErrorMessage = err.localizedDescription
                    self.showLoanErrorAlert = true
                }
            } receiveValue: { [weak self] result in
                guard let self else { return }
                self.loanResult = result
            }
            .store(in: &cancellables)
    }
}

