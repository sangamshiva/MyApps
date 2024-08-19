//
//  GeocodingMgr.swift
//  WeatherApp_Chase
//
//  Created by Shiva Sangam on 8/15/24.
//

import Foundation
import CoreLocation

class GeocodingManager {
    private let geocoder = CLGeocoder()

    //MARK: - Geocode returns coordinates based on city or zipcode
    func geocodeAddress(_ address: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let location = placemarks?.first?.location else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Location not found"])))
                    return
                }

                completion(.success(location.coordinate))
            }
        }
    }
}
