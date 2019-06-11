//
//  IndexingUsecase.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 10/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

protocol IndexingUsecaseProtocol {
    func generateIndexes() -> Future<Bool>
}

struct IndexingUsecase {
    let service: ServiceType
    let indexes: Indexes
    let serialQueue = DispatchQueue(label: "InsuranceUsecaseQueue")
    
    init(service: ServiceType,
         indexes: Indexes = Indexes(for: FACache.citiesIndexesKey)) {
        self.service = service
        self.indexes = indexes
    }
    
    func generateIndexes() -> Future<Bool> {
        if AppEnvironment.current.cache[FACache.isIndexingCompleted] != nil {
            return Future<Bool>(value: true)
        }
        
        let response = Future<Bool>()
        
        DispatchQueue.global(qos: .utility).async {
            self.service.getAllCities()
                .bind { (cities: [CityData]) ->  Future<[Bool]> in
                    return whenAll(cities.map { citiesData -> Future<Bool> in
                        let indexPath = citiesData.getKeyPath()
                        let result = Future<Bool>()
                        
                        self.serialQueue.async {
                        self.indexes.get(forKeyPath: indexPath)
                            .bind { names -> Future<Bool> in
                                guard let fileIndex = names.first else {
                                    let fileName = citiesData.getFileName()
                                    return self.service.save(forKey: fileName)([citiesData])
                                        .bind { _ in
                                            return self.indexes.save(forKeyPath: indexPath, value: fileName) }
                                }
                                
                                return self.service.get(forKey: fileIndex)
                                    .bind {
                                        var citiesValue = $0
                                        if citiesValue.first(where: { $0.getKeyValue() == citiesData.getKeyValue() }) == nil {
                                            citiesValue.append(citiesData)
                                            return self.service.save(forKey: fileIndex)(citiesValue)
                                        } else {
                                            return Future<Bool>(value: true)
                                        }
                                }
                            }.observe {
                                switch $0 {
                                case .success(let success):
                                    response.resolve(with: success)
                                case .failure(let error):
                                    response.reject(with: error)
                                }
                            }
                        }
                        
                        return result
                    })
                }.fmap { value -> Bool in
                    AppEnvironment.current.cache[FACache.isIndexingCompleted] = true
                    return value.reduce(true, { $0 && $1 })
                }.observe {
                    switch $0 {
                    case .success(let success):
                        response.resolve(with: success)
                    case .failure(let error):
                        response.reject(with: error)
                    }
            }
        }
        
        return response
    }
}
