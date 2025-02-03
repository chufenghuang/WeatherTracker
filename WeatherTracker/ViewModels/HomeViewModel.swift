//
//  HomeViewModel.swift
//  WeatherTracker
//
//  Created by Chufeng Huang on 1/29/25.
//

import Foundation
import SwiftUI
import Combine
@MainActor

class HomeViewModel: ObservableObject {
    @Published var cityName: String? = nil
    @Published var temperature: String? = nil
    @Published var humidity: String? = nil
    @Published var uv: String? = nil
    @Published var feelslike: String? = nil
    @Published var iconUrl: String? = nil
    @Published var errorMessage: String? = nil
    @Published var didSelectCity: Bool = false
    @Published var showSearchResultCard: Bool = false
    
    //Variables for astronomy
    @Published var sunrise: String? = nil
    @Published var sunset: String? = nil

    private let weatherService: WeatherAPIServiceProtocol
    private let localStorage: LocalStorageProtocol

    init(weatherService: WeatherAPIServiceProtocol = WeatherAPIService(),
         localStorage: LocalStorageProtocol = LocalDataManager()) {
        self.weatherService = weatherService
        self.localStorage = localStorage
        loadSavedCityOnInit() // Load saved city when ViewModel is created
    }

    /// Loads the saved city from local storage and fetches weather
    private func loadSavedCityOnInit() {
        if let savedCity = localStorage.getSavedCityName(), !savedCity.isEmpty {
            Task {
                await fetchWeather(targetCityName: savedCity)
                didSelectCity = true
            }
        }
    }

    /// Fetch weather for the given city
    func fetchWeather(targetCityName: String) async {
        DispatchQueue.main.async {
            self.errorMessage = nil
            self.showSearchResultCard = false
        }

        do {
            let response = try await weatherService.fetchCurrentWeather(for: targetCityName)

            DispatchQueue.main.async {
                self.cityName = response.location.name
                self.temperature = "\(Int(response.current.temp_c))"
                self.humidity = "\(response.current.humidity)%"
                self.uv = "\(response.current.uv)"
                self.feelslike = "\(response.current.feelslike_c)"

                let rawIcon = response.current.condition.icon
                self.iconUrl = rawIcon.hasPrefix("//") ? "https:" + rawIcon : rawIcon

                self.showSearchResultCard = true
            }
        } catch let error as WeatherAPIError {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.showSearchResultCard = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Unexpected error. Please try again."
                self.showSearchResultCard = false
            }
        }
    }
    
    func fetchAstronomy(targetCityName: String) async {
        DispatchQueue.main.async {
            self.errorMessage = nil
//            self.showSearchResultCard = false
        }

        do {
            let response = try await weatherService.fetchAstronomy(for: targetCityName)

            DispatchQueue.main.async {
                self.sunrise = response.astronomy.astro.sunrise
                self.sunset = response.astronomy.astro.sunset

//                self.showSearchResultCard = true
            }
        } catch let error as WeatherAPIError {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.showSearchResultCard = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Unexpected error. Please try again."
                self.showSearchResultCard = false
            }
        }
    }

    /// Select a city and save it
    func selectCity(_ city: String) {
        localStorage.saveCityName(city)
        cityName = city
        didSelectCity = true
        showSearchResultCard = false
    }

    /// Clear search results
    func clearSearch() {
        showSearchResultCard = false
        didSelectCity = false
    }
    
    func setDidSelectCityValue(newValue:Bool){
        didSelectCity = newValue
    }
    
    func setShowSearchResultCardValue(newValue:Bool){
        showSearchResultCard = newValue
    }
    
    func saveCityNameToLocalStorage(newCityName:String){
        cityName = newCityName
        localStorage.saveCityName(newCityName)
    }
}
