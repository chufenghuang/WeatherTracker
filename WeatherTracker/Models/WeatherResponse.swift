//
//  WeatherResponse.swift
//  WeatherTracker
//
//  Created by Chufeng Huang on 1/29/25.
//

import Foundation
struct WeatherResponse: Decodable {
    let location: Location
    let current: CurrentWeather
    
    struct Location: Decodable {
        let name: String
        let region: String
        let country: String
    }
    
    struct CurrentWeather: Decodable {
        let temp_c: Double
        let humidity: Int
        let uv: Double
        let feelslike_c: Double
        let condition: Condition
        
        struct Condition: Decodable {
            let text: String
            let icon: String
            let code: Int
        }
    }
}
