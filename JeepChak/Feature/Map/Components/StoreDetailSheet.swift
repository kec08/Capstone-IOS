////
////  StoreDetailSheet.swift
////  Eodigo
////
////  Created by 김은찬 on 12/20/25.
////
//
//import SwiftUI
//
//struct StoreDetailSheet: View {
//    let store: StoreDTO
//    let onClose: () -> Void
//
//    @State private var tab: Tab = .home
//    @State private var showPaymentInput = false
//    @State private var showPaymentStatus: PaymentStatus? = nil
//    @StateObject private var paymentVM = WalletPayViewModel()
//    
//    private var walletAddress: String? {
//        WalletManager.shared.loadAddress()
//    }
//
//    enum Tab: String, CaseIterable {
//        case home = "홈"
//        case review = "리뷰"
//        case info = "정보"
//    }
//
//    var body: some View {
//        ZStack {
//            Color.customWhite.ignoresSafeArea()
//
//            VStack(spacing: 0) {
//                header
//                    .padding(.top, 14)
//
//                ScrollView(showsIndicators: false) {
//                    VStack(spacing: 14) {
//                        topCard
//                        contentCard
//                    }
//                    .padding(.horizontal, 14)
//                    .padding(.bottom, 18)
//                    .padding(.top, 10)
//                }
//            }
//        }
//        .sheet(isPresented: $showPaymentInput) {
//            PaymentInputSheet(
//                onCancel: {
//                    showPaymentInput = false
//                },
//                onPay: { amount in
//                    showPaymentInput = false
//                    Task {
//                        await paymentVM.processPayment(amount: amount) { status in
//                            showPaymentStatus = status
//                        }
//                    }
//                }
//            )
//        }
//        .sheet(item: $showPaymentStatus) { status in
//            PaymentStatusView(status: status) {
//                showPaymentStatus = nil
//            }
//        }
//    }
//
//    // MARK: - Header (고정)
//    private var header: some View {
//        HStack(spacing: 12) {
//            Button(action: onClose) {
//                Image(systemName: "chevron.left")
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(.customBlack)
//                    .frame(width: 48, height: 48)
//                    .contentShape(Rectangle())
//            }
//
//            Spacer()
//        }
//        .padding(.horizontal, 12)
//        .padding(.top, 14)
//        .padding(.bottom, 8)
//        .background(Color.white)
//    }
//    
//    private var topCard: some View {
//        VStack(alignment: .leading, spacing: 14) {
//            titleBlock
//
//            heroImage
//
//            tabBar
//        }
//        .padding(.horizontal, 14)
//        .padding(.vertical, 14)
//        .background(cardBg)
//    }
//
//    private var titleBlock: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            HStack(alignment: .top, spacing: 12) {
//                VStack(alignment: .leading, spacing: 6) {
//                    Text(store.storeName)
//                        .font(.system(size: 26, weight: .bold))
//                        .foregroundColor(.black)
//                        .lineLimit(2)
//
//                    Text("가맹점  ·  리뷰 42")
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.gray)
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                    showPaymentInput = true
//                }) {
//                    Text("결제")
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.blue)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.blue, lineWidth: 1.5)
//                        )
//                }
//                .padding(.top, 4)
//                .disabled(walletAddress == nil)
//            }
//        }
//    }
//
//    private var heroImage: some View {
//        ZStack(alignment: .bottomLeading) {
//            Image("franchise_img1")
//                .resizable()
//                .scaledToFill()
//                .frame(height: 210)
//                .clipped()
//                .cornerRadius(18)
//
//            HStack(spacing: 6) {
//                Image(systemName: "map")
//                    .font(.system(size: 12, weight: .semibold))
//                Text("지도 보기")
//                    .font(.system(size: 13, weight: .semibold))
//            }
//            .foregroundColor(.white)
//            .padding(.horizontal, 10)
//            .padding(.vertical, 8)
//            .background(Color.black.opacity(0.35))
//            .cornerRadius(14)
//            .padding(12)
//        }
//    }
//
//    private var tabBar: some View {
//        HStack(spacing: 22) {
//            ForEach(Tab.allCases, id: \.self) { t in
//                Button { tab = t } label: {
//                    VStack(spacing: 10) {
//                        Text(t.rawValue)
//                            .font(.system(size: 16, weight: .semibold))
//                            .foregroundColor(tab == t ? .black : .gray)
//
//                        Rectangle()
//                            .fill(tab == t ? Color.black : Color.clear)
//                            .frame(width: 30, height: 2)
//                            .cornerRadius(1)
//                    }
//                }
//            }
//            Spacer()
//        }
//        .padding(.top, 2)
//    }
//
//    // MARK: - 카드
//    private var contentCard: some View {
//        VStack(alignment: .leading, spacing: 14) {
//            sectionTitle(tab == .home ? "소개" : tab == .review ? "리뷰 요약" : "기본 정보")
//
//            Divider().opacity(0.6)
//
//            if tab == .home {
//                infoRows
//                Text("EDG 토큰으로 결제 가능한 가맹점입니다. 다양한 메뉴와 서비스를 제공하며, 블록체인 기반의 안전한 결제 시스템을 지원합니다.")
//                    .font(.system(size: 16))
//                    .foregroundColor(.customBlack.opacity(0.88))
//                    .lineSpacing(4)
//                    .padding(.top, 10)
//
//            } else if tab == .review {
//                Text("· EDG 토큰 결제가 편리하다는 리뷰가 많습니다.\n· 메뉴 품질과 서비스 만족도가 높습니다.\n· 블록체인 결제 시스템이 안전하고 빠릅니다.")
//                    .font(.system(size: 16))
//                    .foregroundColor(.black.opacity(0.88))
//                    .lineSpacing(4)
//
//            } else {
//                infoRows
//            }
//        }
//        .padding(.horizontal, 14)
//        .padding(.vertical, 14)
//        .background(cardBg)
//    }
//
//    private var infoRows: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            row(icon: "mappin.and.ellipse", title: store.location)
//            if let lat = store.latitudeDouble, let lng = store.longitudeDouble {
//                row(icon: "location", title: "위치: \(String(format: "%.6f", lat)), \(String(format: "%.6f", lng))")
//            }
//        }
//    }
//
//    private func sectionTitle(_ text: String) -> some View {
//        Text(text)
//            .font(.system(size: 18, weight: .bold))
//            .foregroundColor(.black)
//    }
//
//    private func row(icon: String, title: String) -> some View {
//        HStack(alignment: .top, spacing: 10) {
//            Image(systemName: icon)
//                .font(.system(size: 15, weight: .semibold))
//                .foregroundColor(.gray)
//                .frame(width: 18)
//
//            Text(title)
//                .font(.system(size: 16, weight: .medium))
//                .foregroundColor(.black.opacity(0.88))
//
//            Spacer()
//        }
//    }
//
//    private var cardBg: some View {
//        RoundedRectangle(cornerRadius: 18, style: .continuous)
//            .fill(Color.white)
//            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
//    }
//}
//
//#Preview {
//    StoreDetailSheet(
//        store: StoreDTO(
//            id: 1,
//            storeName: "중꿜러반점",
//            address: "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
//            location: "경북 어딘가",
//            latitude: "36.4012",
//            longitude: "128.6650"
//        ),
//        onClose: {}
//    )
//    .preferredColorScheme(.light)
//}
//
