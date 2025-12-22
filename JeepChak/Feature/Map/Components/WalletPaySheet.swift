//
//  WalletPaySheet.swift
//  Eodigo
//
//  Created by 김은찬 on 12/19/25.
//

import SwiftUI
import UIKit

struct WalletPaySheet: View {
    let tokenAmountText: String
    let walletAddress: String?
    
    @StateObject private var vm = WalletPayViewModel()
    @State private var copied = false
    @State private var showPaymentInput = false
    @State private var showPaymentStatus: PaymentStatus? = nil

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // 토큰 이미지
                VStack(spacing: 16) {
                    Image("MyPage_Coin_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.top, 40)
                    
                    // 보유 토큰
                    VStack(spacing: 8) {
                        Text("보유 토큰")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Text(tokenAmountText)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 32)
                
                // 지갑 주소 카드
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("지갑 주소")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        if let addr = walletAddress {
                            Button {
                                UIPasteboard.general.string = addr
                                copied = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    copied = false
                                }
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    
                    if let addr = walletAddress {
                        Text(addr)
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundColor(.customBlue)
                            .textSelection(.enabled)
                            .lineLimit(2)
                        
                        if copied {
                            Text("복사됨")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.black.opacity(0.8))
                                .cornerRadius(10)
                        }
                    } else {
                        Text("지갑이 없습니다. 지갑 생성 후 이용하세요.")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .background(Color.customWhite.ignoresSafeArea())
        .sheet(isPresented: $showPaymentInput) {
            PaymentInputSheet(
                onCancel: {
                    showPaymentInput = false
                },
                onPay: { amount in
                    showPaymentInput = false
                    Task {
                        await vm.processPayment(amount: amount) { status in
                            showPaymentStatus = status
                        }
                    }
                }
            )
        }
        .sheet(item: $showPaymentStatus) { status in
            PaymentStatusView(
                status: status,
                onDismiss: {
                    showPaymentStatus = nil
                    Task {
                        await vm.refreshBalance()
                    }
                }
            )
        }
        .task {
            await vm.refreshBalance()
        }
    }
}
