//
//  Item.swift
//  WeatherTracker
//
//  Created by Chufeng Huang on 1/29/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
