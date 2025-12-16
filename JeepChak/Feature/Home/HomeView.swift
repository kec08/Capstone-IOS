import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var goAddProperty = false

    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.customWhite
                    .ignoresSafeArea()
                
                Color.customBackgroundBlue
                    .frame(height: 720)
                    .ignoresSafeArea(edges: .top)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        VStack(spacing: 24) {
                            HomeHeaderView()
                                .padding(.top, 10)
                                .padding(.horizontal, 20)
                                .padding(.trailing, 24)

                            HomeCategorySectionView()
                                .padding(.horizontal, 20)
                                .padding(.bottom, 28)
                        }
                        .background(Color.customBackgroundBlue)

                        VStack(spacing: 32) {
                            HomePopularSectionView(properties: viewModel.homepopularProperties)
                            HomeRecentSectionView(recentPropeties: viewModel.homerecentProperties)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 100)
                        .background(Color.customWhite)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $goAddProperty) {
                AddCheckListView(
                    addCheckListItem: { _ in },
                    onDismiss: { goAddProperty = false }
                )
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    goAddProperty = true
                } label: {
                    Image("AddButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                }
                .padding(.trailing, 22)
                .padding(.bottom, 30)
            }
        }
    }
}

#Preview { HomeView() }

