//
//  SearchUsecase.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 10/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

protocol SearchUsecaseProtocol {
    func search(byKeyword keyword: String) -> Future<(String, Cities)>
}

struct SearchUsecase: SearchUsecaseProtocol {
    let service: ServiceType
   
    init(service: ServiceType) {
        self.service = service
    }
    
    func search(byKeyword keyword: String) -> Future<(String, Cities)> {
        return self.service.searchCities(for: keyword)
    }
}
