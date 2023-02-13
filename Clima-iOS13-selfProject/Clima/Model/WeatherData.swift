//
//  WeatherData.swift
//  Clima
//
//  Created by Administrator on 11/15/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable{
    
    let name: String
    let main: Main
    let weather: [Weather]
    
    // if any name is wrong spell, won't work?
    
}

struct Main: Codable{
    let temp: Double
    let humidity: Int
}

struct Weather: Codable{
    let id: Int
    let description: String
}
