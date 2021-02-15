//
//  CurrenceModel.swift
//  ExchangeTableViewTest
//
//  Created by Павел Бескоровайный on 26.01.2021.
//

import Foundation

struct Currency: Codable {
    var name: String
    var rate: Float
    var cc: String
    
    enum CodingKeys: String, CodingKey {
        case name = "txt"
        case rate, cc
    }

static func performRequest(_ completion: @escaping (_ isSuccess: Bool, _ response: [Currency]) -> () ) {
    guard let uRL = URL(string: "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json")
    else { return }
    URLSession.shared.dataTask(with: uRL) { (data, response, error) in
       
        var result = [Currency]()
        guard data != nil else {
          print("NO DATA")
          completion(false, result)
          return
        }
        
        guard error == nil else {
          print(error!.localizedDescription)
          completion(false, result)
          return
        }
        
        do {
       result = try JSONDecoder().decode([Currency].self, from: data!)
          completion(true, result)
            print(result.count)
        } catch {
          print(error.localizedDescription)
          completion(false, result)
        }
    }.resume()
}
}
