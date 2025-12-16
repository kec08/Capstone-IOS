//
//  MyView.swift
//  Eodigo
//
//  Created by 김은찬 on 10/4/25.
//

// MyView.swift

import SwiftUI

struct MyView: View {
    @StateObject private var viewModel = MyViewModel(appState: AppState())
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    MyHeaderView(toggleSetting: viewModel.openSettings)

                    ProfileSection(userInfo: viewModel.userInfo)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)

                    StatisticsSection(userInfo: viewModel.userInfo)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 26)

                    RecommendationBanner()
                        .padding(.horizontal, 15)
                        .padding(.bottom, 40)

                    InfoSection(userInfo: viewModel.userInfo)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)

                    Button(action: viewModel.logout) {
                        Text("로그아웃")
                            .font(.system(size: 16).weight(.semibold))
                            .foregroundColor(.customRed)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 50)
                }
            }
            .background(Color.customBackgroundBlue)
        }
        .sheet(isPresented: $viewModel.showSettings) {
            Text("설정 화면")
        }
    }
}

#Preview {
    MyView()
}
