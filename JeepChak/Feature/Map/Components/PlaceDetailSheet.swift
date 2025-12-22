////
////  PlaceDetailSheet.swift
////  Eodigo
////
////  Created by 김은찬 on 12/18/25.
////
//
//import SwiftUI
//
//struct PlaceDetailSheet: View {
//    let spot: TourSpot
//    let onClose: () -> Void
//    let onDeparture: () -> Void
//    let onOpenMap: () -> Void
//
//    @State private var tab: Tab = .home
//    
//    @State private var isSharePresented = false
//    @State private var isShareMenuPresented = false
//    @State private var shareItems: [Any] = []
//    @State private var showRewardProcessing = false
//    @State private var showRewardSuccess = false
//    @State private var isRequestingReward = false
//    
//    private let walletService: WalletServiceProtocol = WalletService()
//    
//    
//    // 임시 목값
//    // 경산실내체육관만 활성화
//    private var isRewardEnabled: Bool {
//        spot.name == "경산실내체육관"
//    }
//    
//    // 경산실내체육관은 인증 제한 없음, 다른 장소는 비활성화
//    private var hasRewarded: Bool {
//        // 경산실내체육관이 아니면 항상 false
//        if !isRewardEnabled {
//            return false
//        }
//        // 경산실내체육관은 제한 없음
//        return false
//    }
//    
//    // 체육관인 경우 500 토큰, 그 외는 priceText에서 추출
//    private var rewardAmount: Int? {
//        if isRewardEnabled {
//            // 경산실내체육관은 500 토큰으로 고정
//            return 500
//        }
//        guard let priceText = spot.priceText else { return nil }
//        let numbers = priceText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
//        return Int(numbers)
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
//        .sheet(isPresented: $showRewardProcessing) {
//            RewardProcessingSheet()
//        }
//        .sheet(isPresented: $showRewardSuccess) {
//            RewardSuccessSheet {
//                showRewardSuccess = false
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
//            actionButtons
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
//                    Text(spot.name)
//                        .font(.system(size: 26, weight: .bold))
//                        .foregroundColor(.black)
//                        .lineLimit(2)
//
//                    Text("\(spot.category)  ·  리뷰 \(spot.reviewCount)")
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.gray)
//                }
//                
//                Spacer()
//                
//                if isRewardEnabled {
//                    Button(action: {
//                        requestReward()
//                    }) {
//                        Text("인증하기")
//                            .font(.system(size: 14, weight: .medium))
//                            .foregroundColor(.blue)
//                            .padding(.horizontal, 16)
//                            .padding(.vertical, 8)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(Color.blue, lineWidth: 1.5)
//                            )
//                    }
//                    .disabled(isRequestingReward)
//                    .padding(.top, 4)
//                } else {
//                    // 비활성화된 경우에도 회색 버튼 표시
//                    Button(action: {}) {
//                        Text("인증하기")
//                            .font(.system(size: 14, weight: .medium))
//                            .foregroundColor(.gray)
//                            .padding(.horizontal, 16)
//                            .padding(.vertical, 8)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(Color.gray, lineWidth: 1.5)
//                            )
//                    }
//                    .disabled(true)
//                    .padding(.top, 4)
//                }
//            }
//        }
//    }
//    
//    private func requestReward() {
//        guard let amount = rewardAmount else { return }
//        
//        // 즉시 처리중 시트 표시
//        showRewardProcessing = true
//        isRequestingReward = true
//        
//        Task {
//            do {
//                let response = try await walletService.requestReward(amount: amount)
//                if response.success {
//                    // 인증 완료 표시 (체육관은 제한 없음)
//                    await MainActor.run {
//                        showRewardProcessing = false
//                        showRewardSuccess = true
//                        isRequestingReward = false
//                    }
//                } else {
//                    await MainActor.run {
//                        showRewardProcessing = false
//                        isRequestingReward = false
//                    }
//                }
//            } catch {
//                print("[REWARD] 인증 실패: \(error.localizedDescription)")
//                await MainActor.run {
//                    showRewardProcessing = false
//                    isRequestingReward = false
//                }
//            }
//        }
//    }
//
//    private var actionButtons: some View {
//        HStack(spacing: 10) {
//            Button(action: onDeparture) {
//                Text("출발")
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.blue)
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 12)
//                    .background(Color.blue.opacity(0.12))
//                    .cornerRadius(18)
//            }
//
//            Button(action: { isShareMenuPresented = true }) {
//                HStack(spacing: 7) {
//                    Image(systemName: "square.and.arrow.up")
//                        .font(.system(size: 15, weight: .semibold))
//                    Text("공유")
//                        .font(.system(size: 16, weight: .semibold))
//                }
//                .foregroundColor(.black)
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 12)
//                .background(Color.black.opacity(0.06))
//                .cornerRadius(18)
//            }
//            .confirmationDialog("공유", isPresented: $isShareMenuPresented, titleVisibility: .visible) {
//                let encoded = spot.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? spot.name
//                let appleMapsURL = URL(string: "http://maps.apple.com/?ll=\(spot.lat),\(spot.lng)&q=\(encoded)")!
//
//                ShareLink(
//                    item: appleMapsURL,
//                    subject: Text(spot.name),
//                    message: Text("\(spot.name)\n\(spot.address)\n좌표: \(spot.lat), \(spot.lng)")
//                ) {
//                    Text("위치 공유하기")
//                }
//            }
//        }
//    }
//    
//    private func shareLocation() {
//            let name = spot.name
//            let address = spot.address
//            let coordText = "\(spot.lat), \(spot.lng)"
//
//            let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
//            let appleMapsURL = URL(string: "http://maps.apple.com/?ll=\(spot.lat),\(spot.lng)&q=\(encodedName)")!
//
//            let message =
//            """
//            \(name)
//            \(address)
//            좌표: \(coordText)
//            """
//
//            shareItems = [message, appleMapsURL]
//            isSharePresented = true
//        }
//
//    private var heroImage: some View {
//        GeometryReader { geometry in
//            Button(action: onOpenMap) {
//                ZStack(alignment: .bottomLeading) {
//                    Image(spot.imageName)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: geometry.size.width, height: 210) // 고정 크기
//                        .clipped()
//                        .contentShape(Rectangle())
//                        .cornerRadius(18)
//
//                HStack(spacing: 6) {
//                    Image(systemName: "map")
//                        .font(.system(size: 12, weight: .semibold))
//                    Text("지도 보기")
//                        .font(.system(size: 13, weight: .semibold))
//                }
//                .foregroundColor(.white)
//                .padding(.horizontal, 10)
//                .padding(.vertical, 8)
//                .background(Color.black.opacity(0.35))
//                .cornerRadius(14)
//                .padding(12)
//                }
//            }
//            .buttonStyle(.plain)
//        }
//        .frame(height: 210)
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
//                Text(spot.description)
//                    .font(.system(size: 16))
//                    .foregroundColor(.customBlack.opacity(0.88))
//                    .lineSpacing(4)
//                    .padding(.top, 10)
//
//            } else if tab == .review {
//                Text("· 조용하고 한적하다는 리뷰가 많습니다.\n· 가족 단위/캠핑/산책 만족도가 높습니다.\n· 주변 상권과 연계하면 체류형 코스로 좋습니다.")
//                    .font(.system(size: 16))
//                    .foregroundColor(.black.opacity(0.88))
//                    .lineSpacing(4)
//
//            } else {
//                infoRows
//                if let website = spot.website {
//                    Text(website)
//                        .font(.system(size: 16, weight: .semibold))
//                        .foregroundColor(.blue)
//                        .padding(.top, 4)
//                }
//            }
//
//            if let price = spot.priceText {
//                Divider().opacity(0.6)
//
//                Text(price)
//                    .font(.system(size: 22, weight: .bold))
//                    .foregroundColor(.black)
//            }
//        }
//        .padding(.horizontal, 14)
//        .padding(.vertical, 14)
//        .background(cardBg)
//    }
//
//    private var infoRows: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            row(icon: "mappin.and.ellipse", title: spot.address)
//            if let phone = spot.phone {
//                row(icon: "phone.fill", title: phone)
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
//// MARK: - ShareSheet
//struct ShareSheet: UIViewControllerRepresentable {
//    let items: [Any]
//
//    func makeUIViewController(context: Context) -> UIActivityViewController {
//        UIActivityViewController(activityItems: items, applicationActivities: nil)
//    }
//
//    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
//}
//
//#Preview {
//    PlaceDetailSheet(
//        spot: TourSpot(
//            name: "의성 빙계 얼음골 야영장",
//            category: "야영장",
//            reviewCount: 28,
//            address: "경북 의성군 춘산면 빙계리 일대",
//            phone: "054-000-0000",
//            website: "https://example.com",
//            description: "여름에도 서늘한 냉기가 내려오는 계곡 지형으로, 한적한 캠핑과 산책이 가능합니다. 인근 소규모 마을 상권과 연계하면 체류형 관광에 좋습니다.",
//            imageName: "home_content1-2_img",
//            priceText: "₩ 600",
//            lat: 36.4012,
//            lng: 128.6650
//        ),
//        onClose: {},
//        onDeparture: {},
//        onOpenMap: {}
//    )
//    .preferredColorScheme(.light)
//}
