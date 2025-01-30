//
//  WeatherTrackerApp.swift
//  WeatherTracker
//
//  Created by Chufeng Huang on 1/29/25.
//

import SwiftUI
import SwiftData

@main
struct WeatherTrackerApp: App {
    let localStorage = LocalDataManager()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear(){
                    print("APP start.. getting settings")
                    print(localStorage.getSavedCityName() ?? "")
                }
        }
    }
}
