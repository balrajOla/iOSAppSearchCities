//
//  Service.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 09/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

protocol ServiceType {
    func searchCities(for keyword: String) -> Future<CityData>?
}

struct Service: ServiceType {
    func searchCities(for keyword: String) -> Future<CityData>? {
        return nil
    }
}
