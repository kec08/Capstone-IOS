//
//  MyView.swift
//  Eodigo
//
//  Created by 김은찬 on 10/4/25.
//

// MyView.swift

import SwiftUI
import Combine

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
                // ✅ iPad 등 큰 화면에서 컨텐츠가 과하게 넓어지지 않도록 최대 폭 제한
                .frame(maxWidth: 600)
                .frame(maxWidth: .infinity)
            }
            .background(Color.customBackgroundBlue)
        }
        .sheet(isPresented: $viewModel.showSettings) {
            MySettingsView()
                .environmentObject(appState)
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

// MARK: - Settings
private struct MySettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState

    @State private var showDeleteConfirm = false
    @State private var isDeleting = false
    @State private var showResultAlert = false
    @State private var resultMessage: String = ""
    @State private var cancellables = Set<AnyCancellable>()

    private let authService = AuthService.shared

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(role: .destructive) {
                        showDeleteConfirm = true
                    } label: {
                        HStack {
                            Text("계정 삭제하기")
                            Spacer()
                            if isDeleting {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(isDeleting)
                } footer: {
                    Text("계정 삭제 시 데이터가 복구되지 않을 수 있습니다.")
                }

                Section {
                    Button(role: .destructive) {
                        appState.logout()
                        dismiss()
                    } label: {
                        Text("로그아웃")
                    }
                }
            }
            .navigationTitle("설정")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("닫기") { dismiss() }
                }
            }
            .alert("계정을 삭제할까요?", isPresented: $showDeleteConfirm) {
                Button("취소", role: .cancel) {}
                Button("삭제", role: .destructive) { deleteAccount() }
            } message: {
                Text("계정 삭제 후 자동으로 로그아웃됩니다.")
            }
            .alert("안내", isPresented: $showResultAlert) {
                Button("확인") {
                    // 삭제 성공이면 이미 로그아웃 처리됨
                    dismiss()
                }
            } message: {
                Text(resultMessage)
            }
        }
    }

    private func deleteAccount() {
        guard !isDeleting else { return }
        isDeleting = true

        Future<String, Error> { promise in
            Task {
                do {
                    let message = try await authService.deleteMe()
                    promise(.success(message))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { completion in
            isDeleting = false
            if case .failure(let e) = completion {
                resultMessage = e.localizedDescription
                showResultAlert = true
            }
        } receiveValue: { message in
            // ✅ 계정 삭제 성공 → 토큰 정리 + 로그아웃
            appState.logout()
            resultMessage = message.isEmpty ? "계정이 삭제되었습니다." : message
            showResultAlert = true
        }
        .store(in: &cancellables)
    }
}


struct MyView_Previews: PreviewProvider {
    static var previews: some View {
            MyView()
    }
}
