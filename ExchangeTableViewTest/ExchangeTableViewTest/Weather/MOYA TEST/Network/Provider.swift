//
//  Provider.swift
//  ExchangeTableViewTest
//
//  Created by Павел Бескоровайный on 09.02.2021.
//

import Foundation
import PromiseKit
import Moya

struct Provider {
    
    static private let provider = MoyaProvider<FetchDataFromAPI>()
    
    static func getWeatherData (city: String, units: String, language: String) -> Promise<GetWeather> {
        return Promise { seal in
            provider.request(.getDataBy(city: city, units: units, language: language)) { result in
                switch result {
                case.success(let response):
                    do {
                        let weatherData = try JSONDecoder().decode(GetWeather.self, from: response.data)
                        seal.fulfill(weatherData)
                    } catch let error {
                        debugPrint(error.localizedDescription)
                        seal.reject(error)
                    }
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    seal.reject(error)
                }
            }
        }
    }
}
