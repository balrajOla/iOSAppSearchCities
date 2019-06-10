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
    
    init(cities: [CityData]) {
        self.info = cities.map { City(city: $0) }
    }
    
    init(cityInfo: [City]) {
        self.info = cityInfo
    }
}

struct City: Codable {
    let key: String
    let detail: CityDetail
    
    init(city: CityData) {
        self.key = city.getKeyValue()
        self.detail = CityDetail(city: city)
    }
}

struct CityDetail: Codable {
    let name: String
    let country: String
    let coordinate: Coordinate
    
   init(city: CityData) {
    self.name = city.name
    self.country = city.country
    self.coordinate = Coordinate(coord: city.coord)
    }
}

struct Coordinate: Codable {
    let lat: Double
    let lon: Double
    
    init(coord: Coord) {
        self.lat = coord.lat
        self.lon = coord.lon
    }
}
