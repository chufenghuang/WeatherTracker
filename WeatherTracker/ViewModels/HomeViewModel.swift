//
//  HomeViewModel.swift
//  WeatherTracker
//
//  Created by Chufeng Huang on 1/29/25.
//

import Foundation
import SwiftUI
@MainActor
class HomeViewModel: ObservableObject{
    // MARK: - Published Properties
    @Published var cityName: String = ""          // Bound to your search text field or displayed city name
    @Published var temperature: String = ""       // E.g., "25°"
    @Published var conditionText: String = ""     // E.g., "Sunny"
    @Published var iconURL: String = ""           // E.g., "https://cdn.weatherapi.com/..."
    @Published var humidity: String = ""          // E.g., "60%"
    @Published var uvIndex: String = ""           // E.g., "5"
    @Published var feelsLike: String = ""        // E.g., "27°"
    
    @Published var errorMessage: String? = nil    // For showing any errors in the UI
    
    // MARK: - Private Dependencies
    private let weatherService: WeatherAPIServiceProtocol
    private let localStorage: LocalStorageProtocol

    // MARK: - Initializer
    init(weatherService: WeatherAPIServiceProtocol = WeatherAPIService(),
         localStorage: LocalStorageProtocol = LocalDataManager()) {
        self.weatherService = weatherService
        self.localStorage = localStorage
        
        // Attempt to load saved city right away
        loadSavedCityOnInit()
    }
    
    // MARK: - Public Methods

    /// Load weather for the current cityName (user typed or loaded from storage).
    func loadWeather() {
        // In SwiftUI, prefer using async/await or a Task:
        Task {
            await fetchWeather(for: cityName)
        }
    }
    
    /// Called when the user selects a new city from a search result.
    /// - Parameter newCity: The new city the user selected (e.g., "Chicago").
    func selectCity(_ newCity: String) {
        cityName = newCity
        localStorage.saveCityName(newCity)
        loadWeather()  // fetch updated weather
    }

    // MARK: - Private Helpers
    
    /// Loads the previously saved city from local storage (if any).
    private func loadSavedCityOnInit() {
        if let savedCity = localStorage.getSavedCityName() {
            cityName = savedCity
            // Optionally auto-fetch weather
            loadWeather()
        } else {
            // If there's no saved city, you might display a placeholder or
            // rely on the user to type a city in the search bar.
            cityName = ""
        }
    }
    
    /// Actually calls the WeatherAPIService to fetch current weather.
    private func fetchWeather(for city: String) async {
        // Clear any old error
        self.errorMessage = nil
        do {
            let response = try await weatherService.fetchCurrentWeather(for: city)
            // Update published properties directly
            updatePublishedProperties(from: response)
        } catch {
            errorMessage = "Error fetching weather: \(error)"
        }
    }
    
    /// Updates @Published properties from a WeatherResponse.
    private func updatePublishedProperties(from response: WeatherResponse) {
        // The city name from the API might differ from user input.
        cityName = response.location.name
        
        let current = response.current
        temperature = "\(Int(current.temp_c))°"
        conditionText = current.condition.text
        iconURL = "https:\(current.condition.icon)"  // WeatherAPI icon often starts with `//`
        
        humidity = "\(current.humidity)%"
        uvIndex = "\(Int(current.uv))"
        feelsLike = "\(Int(current.feelslike_c))°"
    }
}
