//
//  AstronomyResponse.swift
//  WeatherTracker
//
//  Created by Chufeng Huang on 2/3/25.
//

import Foundation
struct AstronomyResponse: Decodable {
    let location: Location
    let astronomy: Astronomy
    
    struct Location: Decodable {
        let name: String
        let region: String
        let country: String
        let lat: Double
        let lon: Double
        let tz_id: String
        let localtime_epoch: Int
        let localtime: String
    }
    
    struct Astronomy: Decodable {
        let astro:Astro
        struct Astro: Decodable{
            let sunrise: String
            let sunset: String
        }
    }
    

}
