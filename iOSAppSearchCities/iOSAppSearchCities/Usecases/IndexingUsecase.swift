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
    
    init(service: ServiceType,
         indexes: Indexes = Indexes(for: FACache.citiesIndexesKey)) {
        self.service = service
        self.indexes = indexes
    }
    
    func generateIndexes() -> Future<Bool> {
        return service.getAllCities()
            .bind { (cities: [CityData]) ->  Future<[Bool]> in
                if let isIndexingDone = AppEnvironment.current.cache[FACache.isIndexingCompleted] as? Bool,
                    isIndexingDone {
                    return Future<[Bool]>(value: [true])
                }
                
                return whenAll(cities.map { citiesData -> Future<Bool> in
                    let indexPath = citiesData.getKeyPath()
                    
                    return self.indexes.get(forKeyPath: indexPath)
                        .bind { names -> Future<Bool> in
                            guard let fileIndex = names.first else {
                                let fileName = citiesData.getFileName()
                                return self.service.save(forKey: fileName)([citiesData])
                                    .bind { _ in self.indexes.save(forKeyPath: indexPath, value: fileName) }
                            }
                            
                            return self.service.get(forKey: fileIndex)
                                .bind {
                                    var citiesValue = $0
                                    citiesValue.append(citiesData)
                                    return self.service.save(forKey: fileIndex)(citiesValue)
                            }
                    }
                })
            }.fmap { value -> Bool in
                AppEnvironment.current.cache[FACache.isIndexingCompleted] = true
                return value.reduce(true, { $0 && $1 })
        }
    }
}
