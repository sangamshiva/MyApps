//
//  ViewModel.swift
//  WeatherApp_Chase
//
//  Created by Shiva Sangam on 8/17/24.
//

import Foundation
import CoreLocation
import UIKit

class WeatherViewModel {
    
    private let networkManager = NetworkManager()
    private let geocodingManager = GeocodingManager()
    
    //MARK: - Using network manager with latitude and longitude as input parameters
    //Updating UI based on the response we get from network manager.
    func fetchWeather(for coordinate: CLLocationCoordinate2D, completion: @escaping (WeatherResponse?) -> Void) {
        networkManager.fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) { result in
            DispatchQueue.main.async {
                UserDefaults.standard.set("\(coordinate.latitude)", forKey: WConstants.currentLattitudeKey)
                UserDefaults.standard.set("\(coordinate.longitude)", forKey: WConstants.currentLongitudeKey)
                
                switch result {
                case .success(let weatherResponse):
                    completion(weatherResponse)
                case .failure(let error):
                    AlertManager.showAlert(error.localizedDescription)
                    completion(nil)
                }
            }
        }
    }
    
    func collectGeocodeAddress(_ city: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        geocodingManager.geocodeAddress(city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coordinate):
                    completion(coordinate)
                case .failure(let error):
                    AlertManager.showAlert(error.localizedDescription)
                    completion(nil)
                }
            }
        }
    }
    
    func collectWeatherIcon(_ iconCode: String, completion: @escaping (UIImage?) -> Void) {
        self.networkManager.fetchIcon(from: iconCode) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func collectCurrentLocation(_ completion: @escaping (CLLocationCoordinate2D) -> Void) {
        LocationManager.shared.collectCurrentLocation { location in
            DispatchQueue.main.async {
                completion(location)
            }
        }
    }
}
