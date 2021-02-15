//
//  Language.swift
//  ExchangeTableViewTest
//
//  Created by Павел Бескоровайный on 10.02.2021.
//

import Foundation

enum Languages: String, CaseIterable {
    case russian = "ru"
    case english = "en"
    case ukranian = "ua"
    
    var nameInPicker: String {
        switch self{
        case .russian: return "Russian"
        case .english: return "English"
        case .ukranian: return "Ukranian"
        }
    }
}
