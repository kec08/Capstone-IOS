import SwiftUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            VStack(spacing: 0) {
                HomeHeaderView()
                    .padding(.horizontal, 20)
                    .padding(.trailing, 24)
                    .padding(.top, 10)
                    .background(Color.customBackgroundBlue)
                
                Color.customBackgroundBlue
                    .frame(height: 18)
            }
            
            // 지도 레이어
            ZStack {
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                    Color.gray.opacity(0.15).ignoresSafeArea()
                } else {
                    NaverMapViewRepresentable(
                        centerLat: .init(
                            get: { viewModel.centerLat },
                            set: { viewModel.centerLat = $0 }
                        ),
                        centerLng: .init(
                            get: { viewModel.centerLng },
                            set: { viewModel.centerLng = $0 }
                        ),
                        properties: viewModel.properties,
                        onTapProperty: { property in
                            viewModel.selectProperty(property)
                        }
                    )
                    .ignoresSafeArea()
                }
            }
        }
        .sheet(isPresented: .init(
            get: { viewModel.isDetailPresented },
            set: { viewModel.isDetailPresented = $0 }
        )) {
            if let property = viewModel.selectedProperty {
                PropertyDetailSheet(
                    property: property,
                    onClose: { viewModel.closeDetail() }
                )
            }
        }
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
            MapView()
    }
}
