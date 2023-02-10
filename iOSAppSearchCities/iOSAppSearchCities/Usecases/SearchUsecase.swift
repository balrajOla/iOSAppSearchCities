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

enum SearchUsecaseError: Error {
    case noData
}

struct SearchUsecase: SearchUsecaseProtocol {
    
    private let fetchingLocationDebounceTime = 0.4
    private var searchFn: ((String) -> Future<(String, Cities)>)?
    
    init(service: ServiceType) {
        self.setup(forService: service)
    }
    
    func search(byKeyword keyword: String) -> Future<(String, Cities)> {
        let response = Future<(String, Cities)>()
        
        self.searchFn?(keyword)
            .observe {
                switch $0 {
                case .success(let value):
                    if value.1.info.count > 0 {
                        response.resolve(with: value)
                    } else {
                        response.reject(with: SearchUsecaseError.noData)
                    }
                case .failure(_ ):
                    response.reject(with: SearchUsecaseError.noData)
                }
        }
        
        return response
    }
    
    private mutating func setup(forService service: ServiceType) {
        self.searchFn = OperationQueue.debounce(delay: fetchingLocationDebounceTime, action: {
            service.searchCities(for: $0)
        })
    }
}
