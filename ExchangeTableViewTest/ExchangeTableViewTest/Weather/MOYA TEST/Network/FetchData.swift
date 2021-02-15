//
//  FetchData.swift
//  ExchangeTableViewTest
//
//  Created by Павел Бескоровайный on 09.02.2021.
//

import Foundation
import Moya

enum FetchDataFromAPI {
    case getDataBy(city: String, units: String, language: String)
}

extension FetchDataFromAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://api.openweathermap.org/")!
    }
    
    var path: String {
        switch self {
        case .getDataBy:
            return "data/2.5/weather"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getDataBy(let city, let units, let language):
            var parameters = [String:Any]()
            parameters["q"] = city
            parameters["units"] = units
            parameters["lang"] = language
            parameters["appid"] = "5640d6741b18d73cde085af57a8bdfd5"
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
