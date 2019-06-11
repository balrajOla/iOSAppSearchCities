//
//  HomeScreenViewModel.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 11/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

enum HomeScreenViewModelError: Error {
    case noData
}

class HomeScreenViewModel {
    private var searchKeyword: String = ""
    private let service: ServiceType
    private let fetchingLocationDebounceTime = 0.4
    private var searchFn: ((String) -> Future<Cities>)?
    private var searchedResponse: Cities?
    
    init(service: ServiceType = Service(indexes: Indexes(for: FACache.citiesIndexesKey))) {
        self.service = service
        
        self.setup()
    }
    
    func search(forKeyword keyword: String) -> Future<Bool> {
        self.searchKeyword = keyword
        let response = Future<Bool>()
        
        self.searchFn?(self.searchKeyword)
            .observe {
                switch $0 {
                case .success(let value):
                    self.searchedResponse = value
                    response.resolve(with: true)
                case .failure(_ ):
                    self.searchedResponse = nil
                    response.reject(with: HomeScreenViewModelError.noData)
                }
        }
        
        return response
    }
    
    
    private func setup() {
       self.searchFn = OperationQueue.debounce(delay: fetchingLocationDebounceTime, action: { self.service.searchCities(for: $0) })
    }
}
