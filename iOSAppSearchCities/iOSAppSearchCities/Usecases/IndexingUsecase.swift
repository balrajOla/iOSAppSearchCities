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

class IndexingUsecase {
    private let service: ServiceType
    private let serialQueue = DispatchQueue(label: "InsuranceUsecaseQueue")
   
    private var isIndexing: Future<Bool> = Future<Bool>()
    private var indexingDict: [String: IndexManagerUsecase] = [String: IndexManagerUsecase]()
    
    
    public static let sharedInstance = IndexingUsecase(service: Service())
    
    private init(service: ServiceType) {
        self.service = service
        
        self.isIndexing = self.generateIndexes()
    }
    
    public func indexing() -> Future<Bool> {
        return self.isIndexing
    }
    
    private func generateIndexes() -> Future<Bool> {
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
                        
                        DispatchQueue.global(qos: .utility).async {
                        self.getIndexing(forKeyPath: indexPath)
                            .bind {
                                $0.save(data: citiesData)
                            }.observe {
                                switch $0 {
                                case .success(let success):
                                    result.resolve(with: success)
                                case .failure(let error):
                                    result.reject(with: error)
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
    
    private func getIndexing(forKeyPath keyPath: IndexKeyPath) -> Future<IndexManagerUsecase> {
        let response = Future<IndexManagerUsecase>()
        serialQueue.async {
            if let uc = self.indexingDict[keyPath.path] {
                response.resolve(with: uc)
            } else {
                let uc = IndexManagerUsecase(forKey: keyPath)
                self.indexingDict[keyPath.path] = uc
                response.resolve(with: uc)
            }
        }
        return response
    }
}
