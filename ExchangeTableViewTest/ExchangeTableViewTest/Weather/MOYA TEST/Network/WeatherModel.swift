//
//  WeatherModel.swift
//  ExchangeTableViewTest
//
//  Created by Павел Бескоровайный on 31.01.2021.
//

import Foundation

struct GetWeather: Codable {
    var name: String
    var main: Main
    var sys: Sys
    var weather: [Weather]
}


// MARK: - Main
struct Main: Codable {
    var temp, tempMin, tempMax, pressure, humidity: Double
    var feelsLike: Double
    

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let main, weatherDescription: String

    enum CodingKeys: String, CodingKey {
        case main
        case weatherDescription = "description"
    }
}
