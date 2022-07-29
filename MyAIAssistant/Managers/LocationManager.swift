//
//  LocationManager.swift
//  MyAIAssistant
//
//  Created by Nusret Kızılaslan on 29.07.2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var permissionAccepted: Bool?
    static let shared = LocationManager()
    
    
    override init() {
        super.init()
        permissionAccepted = false
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last?.coordinate else {return}
        location = newLocation
        print("location \(newLocation)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("DEBUG: Not determined")
            permissionAccepted = false
        case .restricted:
            print("DEBUG: Not determined")
            permissionAccepted = false
        case .denied:
            print("DEBUG: ")
            permissionAccepted = false
        case .authorizedAlways:
            print("DEBUG: Auth always")
            permissionAccepted = true
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use")
            permissionAccepted = true
        @unknown default:
            break
        }
    }
    
}
