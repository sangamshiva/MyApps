//
//  Networking.swift
//  WeatherApp_Chase
//
//  Created by Shiva Sangam on 8/15/24.
//

import Foundation
import UIKit

class NetworkManager {
    private let apiKey = "621468a8a852d8807d4f427766022b6f" // Replace with your OpenWeatherMap API key
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    //MARK: - Returns weather response with coordinates as input params
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // Function to fetch an image from a URL
    func fetchIcon(from iconCode: String, completion: @escaping (UIImage?) -> Void) {
        
        let iconURLString = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
        // Ensure the URL is valid
        guard let url = URL(string: iconURLString) else {
            completion(nil)
            return
        }
        
        // Create a data task to fetch the image
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle error or invalid data
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            
            // Convert data to UIImage
            let image = UIImage(data: data)
            // Call the completion handler with the image
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        // Start the data task
        task.resume()
    }
}
