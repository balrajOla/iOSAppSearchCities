//
//  CitiesData.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 09/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

struct CityData: Codable {
    let country: String
    let name: String
    let id: Int
    let coord: Coord
    
    private enum CodingKeys: String, CodingKey {
        case country
        case name
        case id = "_id"
        case coord
    }
    
    func getKeyPath() -> KeyPath {
        return "\(name)_\(country)".lowercased().keyPath()
    }
    
    func getFileName() -> String {
        return getKeyPath().segments.last ?? country
    }
    
    func getKeyValue() -> String {
        return "\(name)_\(country)".lowercased()
    }
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}
