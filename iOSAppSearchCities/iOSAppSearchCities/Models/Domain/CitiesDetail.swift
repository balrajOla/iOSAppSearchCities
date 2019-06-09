//
//  CitiesDetail.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 09/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

struct Cities: Codable {
    let info: [City]
}

struct City: Codable {
    let key: String
    let detail: CityDetail
}

struct CityDetail: Codable {
    let name: String
    let country: String
    let coordinate: Coordinate
}

struct Coordinate: Codable {
    let lat: Double
    let lon: Double
}
