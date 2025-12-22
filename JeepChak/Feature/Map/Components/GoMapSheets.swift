//
//  GoMapSheets.swift
//  Eodigo
//
//  Created by 김은찬 on 12/19/25.
//

import SwiftUI

struct GoMapSheets: ViewModifier {
    @ObservedObject var vm: GoMapViewModel
    @Binding var isWalletPresented: Bool

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $vm.isDetailPresented) {
                if let spot = vm.selectedSpot {
                    PlaceDetailSheet(
                        spot: spot,
                        onClose: { vm.closeDetail() },
                        onDeparture: {
                            // TODO: 길찾기
                        },
                        onOpenMap: { vm.closeDetail() }
                    )
                    .presentationDetents([.fraction(0.35), .medium, .large])
                    .presentationBackgroundInteraction(.enabled)
                    .presentationDragIndicator(.visible)
                }
            }
            .sheet(isPresented: $isWalletPresented) {
                WalletPaySheet(
                    tokenAmountText: "2000.00 EDG",
                    walletAddress: WalletManager.shared.loadAddress()
                )
                .presentationDetents([.fraction(0.45), .medium])
                .presentationDragIndicator(.visible)
            }
    }
}
