//
//  GoMapView.swift
//  Eodigo
//
//  Created by 김은찬 on 9/8/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    var body: some View {
        ZStack {
            Map(position: $position)
                .mapStyle(.standard)
            
            VStack {
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        position = .region(
                            MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        )
                    }) {
                        Image(systemName: "location.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    MapView()
}
