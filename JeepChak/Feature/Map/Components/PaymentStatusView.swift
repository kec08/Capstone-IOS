//
//  PaymentStatusView.swift
//  Eodigo
//
//  Created by 김은찬 on 12/20/25.
//

import SwiftUI

enum PaymentStatus: Identifiable, Equatable {
    case success
    case failure(String)
    
    var id: String {
        switch self {
        case .success:
            return "success"
        case .failure(let message):
            return "failure_\(message)"
        }
    }
    
    static func == (lhs: PaymentStatus, rhs: PaymentStatus) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (.failure(let lhsMessage), .failure(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

struct PaymentStatusView: View {
    let status: PaymentStatus
    let onDismiss: () -> Void
    
    @State private var walletBalance: Double = 0.0
    @State private var walletAddress: String? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                // 상태 아이콘
                Image(systemName: statusIcon)
                    .font(.system(size: 50))
                    .foregroundColor(statusColor)
                    .padding(.top, 8)
            }
            
            // 메시지
            VStack(spacing: 8) {
                Text(statusMessage)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                if case .failure(let message) = status {
                    Text(message)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
            // 보유 토큰 정보
            if case .success = status {
                VStack(spacing: 16) {
                    Divider()
                        .padding(.top, 32)
                    
                    VStack(spacing: 12) {
                        Text("보유 토큰")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Text(formatTokenAmount(walletBalance))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .padding(.vertical, 20)
                    
                    // 지갑 주소
                    if let address = walletAddress {
                        VStack(spacing: 8) {
                            Text("지갑 주소")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Text(address)
                                .font(.system(size: 13, design: .monospaced))
                                .foregroundColor(.customBlue)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                        }
                        .padding(.bottom, 20)
                    }
                }
                .padding(.horizontal, 24)
            }
            
            Spacer()
            
            // 확인 버튼
            Button(action: onDismiss) {
                Text("확인")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(statusColor)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            loadWalletInfo()
        }
    }
    
    private func loadWalletInfo() {
        walletAddress = WalletManager.shared.loadAddress()
        Task {
            do {
                let service = WalletService()
                let wallet = try await service.getWallet()
                await MainActor.run {
                    walletBalance = wallet.balance
                }
            } catch {
                print("[PAYMENT] 지갑 정보 로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func formatTokenAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 0
        return (formatter.string(from: NSNumber(value: amount)) ?? "0") + " EDG"
    }
    
    private var statusIcon: String {
        switch status {
        case .success:
            return "checkmark.circle.fill"
        case .failure:
            return "xmark.circle.fill"
        }
    }
    
    private var statusColor: Color {
        switch status {
        case .success:
            return .green
        case .failure:
            return .red
        }
    }
    
    private var statusMessage: String {
        switch status {
        case .success:
            return "결제가 완료되었습니다"
        case .failure(let message):
            return message
        }
    }
}

#Preview {
    PaymentStatusView(
        status: .success,
        onDismiss: {}
    )
}

