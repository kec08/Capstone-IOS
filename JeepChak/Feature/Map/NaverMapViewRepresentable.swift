import SwiftUI
import NMapsMap
import QuartzCore

struct NaverMapViewRepresentable: UIViewRepresentable {
    @Binding var centerLat: Double
    @Binding var centerLng: Double
    let properties: [MapProperty]
    let onTapProperty: (MapProperty) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(onTapProperty: onTapProperty) }

    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView(frame: .zero)
        mapView.mapType = .basic
        mapView.isNightModeEnabled = false

        context.coordinator.mapView = mapView
        context.coordinator.applyMarkers(properties: properties)

        context.coordinator.moveCameraIfNeeded(lat: centerLat, lng: centerLng, animated: false)

        return mapView
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {
        context.coordinator.mapView = uiView

        context.coordinator.moveCameraIfNeeded(lat: centerLat, lng: centerLng, animated: true)

        // 마커는 properties 바뀔 때만 갱신
        context.coordinator.applyMarkersIfNeeded(properties: properties)
    }

    final class Coordinator: NSObject {
        weak var mapView: NMFMapView?
        private var markers: [Int: NMFMarker] = [:]
        private let onTapProperty: (MapProperty) -> Void

        private var lastLat: Double?
        private var lastLng: Double?
        private var lastPropertyCount: Int = -1

        init(onTapProperty: @escaping (MapProperty) -> Void) {
            self.onTapProperty = onTapProperty
        }

        func moveCameraIfNeeded(lat: Double, lng: Double, animated: Bool) {
            guard let mapView else { return }

            if let a = lastLat, let b = lastLng {
                let d = abs(a - lat) + abs(b - lng)
                if d < 0.000001 { return }
            }

            lastLat = lat
            lastLng = lng

            let update = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
            update.animation = animated ? .easeIn : .none

            if animated {
                CATransaction.begin()
                CATransaction.setAnimationDuration(1.8)
                mapView.moveCamera(update)
                CATransaction.commit()
            } else {
                mapView.moveCamera(update)
            }
        }

        func applyMarkersIfNeeded(properties: [MapProperty]) {
            if properties.count == lastPropertyCount { return }
            lastPropertyCount = properties.count
            applyMarkers(properties: properties)
        }

        func applyMarkers(properties: [MapProperty]) {
            guard let mapView else { return }

            let newIds = Set(properties.map { $0.id })
            for (id, marker) in markers where !newIds.contains(id) {
                marker.mapView = nil
                markers.removeValue(forKey: id)
            }

            for property in properties {
                let marker = markers[property.id] ?? NMFMarker()
                marker.position = NMGLatLng(lat: property.lat, lng: property.lng)
                marker.width = 28
                marker.height = 36
                marker.iconImage = NMF_MARKER_IMAGE_BLACK
                marker.iconTintColor = UIColor.systemBlue
                marker.mapView = mapView

                marker.touchHandler = { [weak self] _ in
                    self?.onTapProperty(property)
                    return true
                }

                markers[property.id] = marker
            }
        }
    }
}
