//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Shiva Sangam on 18/08/24.
//

import XCTest
import CoreLocation

@testable import WeatherApp_Chase

final class WeatherAppTests: XCTestCase {
    
    var viewModel: WeatherViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewModel = WeatherViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.viewModel = nil
    }
    
    func testFetchWeatherSuccess() throws {
        let expectation = expectation(description: "fetchWeather")
        let testCoordinate = CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417)
        self.viewModel?.fetchWeather(for: testCoordinate, completion: { result in
            if let result = result {
                expectation.fulfill()
            } else {
                XCTFail()
            }
        })
        
        wait(for: [expectation])
    }
    
    func testFetchWeatherFailure() throws {
        let expectation = expectation(description: "fetchWeather")
        let testCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        self.viewModel?.fetchWeather(for: testCoordinate, completion: { result in
            if result == nil {
                expectation.fulfill()
            } else {
                XCTFail()
            }
        })
        wait(for: [expectation])
    }
}
