//
//  LocalDataManager.swift
//  WeatherTracker
//
//  Created by Chufeng Huang on 1/29/25.
//

import Foundation

// MARK: - Protocol

protocol LocalStorageProtocol {
    /// Saves the provided city name to persistent storage.
    func saveCityName(_ cityName: String)
    
    /// Retrieves the saved city name from persistent storage, or nil if not found.
    func getSavedCityName() -> String?
}

// MARK: - Implementation

class LocalDataManager: LocalStorageProtocol {
    
    private let userDefaults: UserDefaults
    private let selectedCityKey = "SelectedCityKey"
    
    // MARK: - Initializer
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Protocol Methods
    
    func saveCityName(_ cityName: String) {
        userDefaults.set(cityName, forKey: selectedCityKey)
    }
    
    func getSavedCityName() -> String? {
        userDefaults.string(forKey: selectedCityKey)
    }
}
