//
//  MyView.swift
//  Eodigo
//
//  Created by 김은찬 on 10/4/25.
//

import SwiftUI

struct MyView: View {
    @StateObject private var viewModel = MyViewModel()

    var body: some View {
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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)

                InfoSection(userInfo: viewModel.userInfo)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)

                Button(action: viewModel.logout) {
                    Text("로그아웃")
                        .font(.system(size: 16) .weight(.semibold))
                        .foregroundColor(.customRed)
                }
                .padding(.bottom, 40)
            }
        }
        .background(Color.customBackgroundBlue)
        .sheet(isPresented: $viewModel.showSettings) {
            Text("설정 화면")
        }
    }
}
#Preview {
    MyView()
}
