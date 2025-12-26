//
//  MyView.swift
//  Eodigo
//
//  Created by 김은찬 on 10/4/25.
//

// MyView.swift

import SwiftUI

struct MyView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = MyViewModel()
    @State private var showLogoutAlert: Bool = false

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

                    Button(action: { showLogoutAlert = true }) {
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
        .alert("로그아웃", isPresented: $showLogoutAlert) {
            Button("취소", role: .cancel) {}
            Button("로그아웃", role: .destructive) {
                appState.logout()
            }
        } message: {
            Text("정말 로그아웃 하시겠어요?")
        }
    }
}


struct MyView_Previews: PreviewProvider {
    static var previews: some View {
            MyView()
    }
}
