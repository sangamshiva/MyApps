//
//  LocationManager.swift
//  WeatherApp_Chase
//
//  Created by Shiva Sangam on 18/08/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var completionBlock: ((CLLocationCoordinate2D) -> Void)?
    private override init(){
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func collectCurrentLocation(_ completion: @escaping (CLLocationCoordinate2D) -> Void) {
        if let lattitude = UserDefaults.standard.string(forKey: WConstants.currentLattitudeKey), let longitude = UserDefaults.standard.string(forKey: WConstants.currentLongitudeKey), let latValue = Double(lattitude), let longValue = Double(longitude) {
            completion(CLLocationCoordinate2D(latitude: latValue, longitude: longValue))
        } else {
            self.completionBlock = completion
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("Latitude: \(latitude), Longitude: \(longitude)")
            
            DispatchQueue.main.async {
                self.completionBlock?(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }
            // Stop updating location to save battery life (optional)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Location Error: \(error.localizedDescription)")
    }
    
}
