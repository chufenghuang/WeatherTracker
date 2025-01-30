//
//  LocalDataManagerTests.swift
//  WeatherTrackerTests
//
//  Created by Chufeng Huang on 1/29/25.
//

import XCTest
@testable import WeatherTracker

final class LocalDataManagerTests: XCTestCase {
    func testSaveAndGetCityName() {
        let testDefaults = UserDefaults(suiteName: "TestDefaults")!
        // Clear it before test
        testDefaults.removePersistentDomain(forName: "TestDefaults")
        
        let localDataManager = LocalDataManager(userDefaults: testDefaults)
        
        localDataManager.saveCityName("Chicago")
        
        let savedCity = localDataManager.getSavedCityName()
        XCTAssertEqual(savedCity, "Chicago")
    }
}
