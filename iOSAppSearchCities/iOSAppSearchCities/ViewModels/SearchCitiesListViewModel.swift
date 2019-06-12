//
//  HomeScreenViewModel.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 11/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

enum HomeScreenViewModelError: Error {
    case oldRequest
    case noData
}

class SearchCitiesListViewModel {
    private var searchKeyword: String = ""
    private let serachUC: SearchUsecase
    private let fetchingLocationDebounceTime = 0.4
    private var searchFn: ((String) -> Future<(String, Cities)>)?
    private var searchedResponse: Cities?
    
    init(serachUC: SearchUsecase = SearchUsecase(service: Service(indexes: Indexes(for: FACache.citiesIndexesKey)))) {
        self.serachUC = serachUC
        
        self.setup()
    }
    
    func search(forKeyword keyword: String) -> Future<Bool> {
        self.searchKeyword = keyword
        let response = Future<Bool>()
        
        self.searchFn?(self.searchKeyword)
            .observe {
                switch $0 {
                case .success(let value):
                    if self.searchKeyword == value.0 {
                        self.searchedResponse = value.1
                        
                        if value.1.info.count > 0 {
                            response.resolve(with: true)
                        } else {
                            response.reject(with: HomeScreenViewModelError.noData)
                        }
                        
                    } else {
                        response.reject(with: HomeScreenViewModelError.oldRequest)
                    }
                    
                case .failure(_ ):
                    self.searchedResponse = nil
                    response.reject(with: HomeScreenViewModelError.noData)
                }
        }
        
        return response
    }
    
    func getMapViewModel(forIndex index: Int) -> MapScreenViewModel? {
        guard let selectedData = self.searchedResponse?.info[index] else {
            return nil
        }
        
        return MapScreenViewModel(cityDetail: selectedData.detail)
    }
    
    func getTotalCitiesCount() -> Int {
        return self.searchedResponse?.info.count ?? 0
    }
    
    public func getCityDetail(forIndex index: Int) -> City? {
        return self.searchedResponse?.info[index]
    }
    
    private func setup() {
        self.searchFn = OperationQueue.debounce(delay: fetchingLocationDebounceTime, action: { self.serachUC.search(byKeyword: $0) })
    }
}
