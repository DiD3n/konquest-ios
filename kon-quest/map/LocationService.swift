import CoreLocation
import SwiftUI

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    
    private let manager = CLLocationManager()
    @Published var didRequest = false
    
    private override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestPermissionIfNeeded() {
        guard !didRequest else { return }
        DispatchQueue.main.async {
            self.manager.requestWhenInUseAuthorization()
            self.didRequest = true
        }
    }
} 
