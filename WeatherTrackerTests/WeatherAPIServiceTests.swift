//
//  WeatherAPIServiceTests.swift
//  WeatherTrackerTests
//
//  Created by Chufeng Huang on 1/29/25.
//

import XCTest
@testable import WeatherTracker

class WeatherAPIServiceTests: XCTestCase {

    func testFetchCurrentWeather() async throws {
        let service = WeatherAPIService(apiKey: "becbadc1362647bea7a184232252901")
        do {
            let response = try await service.fetchCurrentWeather(for: "Chicago")
            print("\nTest for the city of Chicago:")
            print("\nCurrent Weather: \(response.current)")
            print("\nLocation Name: \(response.location.name)")
        } catch {
            XCTFail("Error fetching weather: \(error)")
        }
    }
}
