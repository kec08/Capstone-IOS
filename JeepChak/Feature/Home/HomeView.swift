//
//  HomeView.swift
//  Eodigo
//
//  Created by 김은찬 on 9/8/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.customBackgroundBlue
                    .ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        // MARK: - 파란 배경 영역
                        VStack(spacing: 24) {
                            HomeHeaderView()
                                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 10)
                                .padding(.horizontal, 20)
                                .padding(.trailing, 24)

                            HomeCategorySectionView()
                                .padding(.horizontal, 20)
                                .padding(.bottom, 28)
                        }

                        // MARK: - 흰색 영역
                        VStack(spacing: 32) {
                            HomePopularSectionView(properties: viewModel.homepopularProperties)
                            HomeRecentSectionView(recentPropeties: viewModel.homerecentProperties)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 80)
                        .background(.customWhite)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

