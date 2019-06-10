//
//  SearchUsecase.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 10/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

protocol SearchUsecaseProtocol {
    func search(byKeyword keyword: String) -> Future<Cities>
}

struct SearchUsecase: SearchUsecaseProtocol {
    func search(byKeyword keyword: String) -> Future<Cities> {
        return Future<Cities>()
    }
}
