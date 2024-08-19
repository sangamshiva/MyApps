//
//  ViewController.swift
//  WeatherApp_Chase
//
//  Created by Shiva Sangam on 8/15/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    let weatherVM = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.weatherVM.collectCurrentLocation { location in
            self.loadWeatherReport(for: location)
        }
    }
    
    //MARK: - Get weather based on users input city/zipcode and button click
    //Using geocoding to get latitude and longitude of city
    @IBAction func fetchWeatherButtonTapped(_ sender: UIButton) {
        guard let city = cityTextField.text, !city.isEmpty else {
            AlertManager.showAlert("Please enter a city name.")
            return
        }
        
        self.weatherVM.collectGeocodeAddress(city) { [weak self] coordinates in
            if let coordinates = coordinates {
                self?.loadWeatherReport(for: coordinates)
            }
        }
    }
    
    func loadWeatherReport(for coordinate: CLLocationCoordinate2D) {
        self.weatherVM.fetchWeather(for: coordinate) { result in
            if let weatherResponse = result {
                self.updateUI(with: weatherResponse)
            }
        }
    }
    
    //MARK: - Updating UI
    private func updateUI(with weatherResponse: WeatherResponse) {
        let temp = (weatherResponse.main.temp * 9/5) + 32
        let desc = weatherResponse.weather.first?.description ?? "No description available"
        let finalStr = "City: \(weatherResponse.name)\n" + "Temperature: \(String(format: "%.1f", temp))°F\n" + "Status: \(desc)"
        
        weatherLabel.text = finalStr
        
        guard let iconCode = weatherResponse.weather.first?.icon else { print("No icon found."); return }
        
        self.weatherVM.collectWeatherIcon(iconCode) { image in
            if let image = image {
                // Do something with the image, e.g., update the UI
                self.weatherIconImageView.image = image
            } else {
                // Handle the error or empty image case
                print("Failed to load image")
            }
        }
    }
}
