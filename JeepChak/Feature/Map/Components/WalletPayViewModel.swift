//
//  WalletPayViewModel.swift
//  Eodigo
//

import Foundation
import Combine

@MainActor
final class WalletPayViewModel: ObservableObject {
    @Published var currentBalance: Double = 0.0
    @Published var isProcessing: Bool = false

    private let service: WalletServiceProtocol

    init(service: WalletServiceProtocol = WalletService()) {
        self.service = service
    }

    func formatTokenAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "0"
    }

    func refreshBalance() async {
        guard WalletManager.shared.hasWallet() else {
            currentBalance = 0.0
            return
        }

        do {
            let wallet = try await service.getWallet()
            currentBalance = wallet.balance
        } catch {
            currentBalance = 0.0
            print("[WALLET] balance fetch failed:", error.localizedDescription)
        }
    }

    func processPayment(amount: String, completion: @escaping (PaymentStatus) -> Void) async {
        guard let fromAddress = WalletManager.shared.loadAddress() else {
            completion(.failure("지갑 주소를 불러올 수 없습니다."))
            return
        }

        isProcessing = true
        defer { isProcessing = false }

        do {
            // 고정값들 (HTML과 동일 구조)
            let tokenContract = "0x62Bd025A5E016288e2d6A3019F44B39E332253bd"     // == message.to (토큰 컨트랙트)
            let storeWallet   = "0xcb1773Da7d2057a9feaAFE7D82B33D0625178853"     // transfer recipient (상점지갑)
            let value = "0"
            let gas = "1000000"
            let forwarderAddress = "0x22E3F2aBd5443F4D5deDd797530bF138E23Ed0A2"
            let chainId = 1337
            let storeId = 1

            // nonce는 백엔드 요청
            let nonce = try await service.requestNonce()

            // deadline: Int (seconds)
            let deadline = Int(Date().timeIntervalSince1970) + 3600

            // Transfer calldata: transfer(storeWallet, amount)  (decimals=0)
            let data = try WalletManager.shared.generateERC20TransferData(
                to: storeWallet,
                amount: amount
            )

            // EIP-712 signature (MetaMask working format에 맞춤)
            let signature = try WalletManager.shared.signMetaTransaction(
                from: fromAddress,
                tokenContract: tokenContract,
                value: value,
                gas: gas,
                nonce: nonce,
                deadline: deadline,
                data: data,
                forwarderAddress: forwarderAddress,
                chainId: chainId
            )

            let paymentRequest = PaymentRequest(
                from: fromAddress,
                to: tokenContract,
                value: value,
                paymentValue: amount,
                gas: gas,
                nonce: nonce,
                deadline: String(deadline),
                data: data,
                signature: signature,
                forwarderAddress: forwarderAddress,
                chainId: chainId
            )

            let response = try await service.storePayment(storeId: storeId, request: paymentRequest)
            print("[PAYMENT] 결제 성공:", response)

            await refreshBalance()
            completion(.success)

        } catch {
            print("[PAYMENT] 결제 실패:", error.localizedDescription)
            completion(.failure("결제에 실패했습니다."))
        }
    }
}
