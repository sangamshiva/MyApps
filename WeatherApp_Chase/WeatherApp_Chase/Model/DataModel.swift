//
//  DataModel.swift
//  WeatherApp_Chase
//
//  Created by Shiva Sangam on 8/15/24.
//

import Foundation


//Defining data structure
struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
    let sys: Sys
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
    
    struct Sys: Codable {
        let country: String
    }
}
