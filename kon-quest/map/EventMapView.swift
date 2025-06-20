import SwiftUI
import MapKit
import UIKit

struct EventMapView: UIViewRepresentable {
    let event: Event
    let selectedQuestId: Int?
    
    init(event: Event, selectedQuestId: Int? = nil) {
        self.event = event
        self.selectedQuestId = selectedQuestId
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        // Enable user location tracking
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        let polygons = polygonsFromGeometryString(event.geometry)

        if let polygon = polygons.first {
            print("EventMapView - loaded geometry")
            mapView.addOverlay(polygon)
            mapView.setVisibleMapRect(
                polygon.boundingMapRect,
                edgePadding: .init(top: 80, left: 40, bottom: 100, right: 40),
                animated: true
            )
        } else {
            print("EventMapView - failed to load geometry")
            // fallback center if no geometry
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            mapView.setRegion(region, animated: false)
        }

        // Add quest points if a quest is selected
        if let questId = selectedQuestId {
            addQuestPoints(for: questId, to: mapView)
        }

        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Remove all overlays and annotations
        uiView.removeOverlays(uiView.overlays)
        uiView.removeAnnotations(uiView.annotations)
        
        let polygons = polygonsFromGeometryString(event.geometry)
        if let polygon = polygons.first {
            uiView.addOverlay(polygon)
            uiView.setVisibleMapRect(
                polygon.boundingMapRect,
                edgePadding: .init(top: 80, left: 40, bottom: 100, right: 40),
                animated: true
            )
        } else {
            // fallback center if no geometry
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            uiView.setRegion(region, animated: false)
        }
        
        // Add quest points if a quest is selected
        if let questId = selectedQuestId {
            addQuestPoints(for: questId, to: uiView)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // MARK: - Quest Points Management
    
    private func addQuestPoints(for questId: Int, to mapView: MKMapView) {
        guard let quest = event.quests?.first(where: { $0.id == questId }),
              let points = quest.points,
              !points.isEmpty else {
            print("EventMapView - no points found for quest \(questId)")
            return
        }
        
        print("EventMapView - adding \(points.count) points for quest \(questId)")
        
        for (index, point) in points.enumerated() {
            guard point.count >= 2 else { continue }
            
            let coordinate = CLLocationCoordinate2D(
                latitude: point[1],  // GeoJSON format: [longitude, latitude]
                longitude: point[0]
            )
            
            let annotation = QuestPointAnnotation(
                coordinate: coordinate,
                questId: questId,
                pointIndex: index,
                title: quest.name,
                subtitle: "Point \(index + 1)"
            )
            
            mapView.addAnnotation(annotation)
        }
    }

    // --- Helper: decode GeoJSON string to [MKPolygon]
    private func polygonsFromGeometryString(_ geoString: String?) -> [MKPolygon] {
        guard
            let geoString = geoString,
            let data = geoString.data(using: .utf8)
        else { return [] }

        do {
            let features = try MKGeoJSONDecoder().decode(data)
            return features
                .compactMap { $0 as? MKGeoJSONFeature }
                .flatMap { $0.geometry }
                .compactMap { $0 as? MKPolygon }
        } catch {
            print("GeoJSON decode error:", error)
            return []
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                renderer.fillColor = UIColor.blue.withAlphaComponent(0.15) // Brighter red fill
                renderer.strokeColor = UIColor.systemBlue.withAlphaComponent(0.8) // Strong red outline
                renderer.lineWidth = 3 // Slightly thicker outline
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Don't customize user location annotation
            if annotation is MKUserLocation {
                return nil
            }
            
            // Custom annotation for quest points
            if let questAnnotation = annotation as? QuestPointAnnotation {
                let identifier = "QuestPoint"
                let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                annotationView.markerTintColor = UIColor.systemGreen
                annotationView.glyphText = "🎯"
                annotationView.canShowCallout = true
                
                return annotationView
            }
            
            return nil
        }
    }
}

// MARK: - Quest Point Annotation

class QuestPointAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let questId: Int
    let pointIndex: Int
    let title: String?
    let subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, questId: Int, pointIndex: Int, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.questId = questId
        self.pointIndex = pointIndex
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
}
