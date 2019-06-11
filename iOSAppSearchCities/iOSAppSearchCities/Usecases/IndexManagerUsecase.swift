//
//  IndexManagerUsecase.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 11/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

struct IndexManagerUsecase {
    private let queue: DispatchQueue
    private var index: Future<String>
    private let service: ServiceType
    private let keyPath: KeyPath
    
    init(forKey keyPath: KeyPath) {
        self.service = Service()
        self.queue = DispatchQueue(label: keyPath.path)
        self.keyPath = keyPath
        
        self.index = Indexes(for: FACache.citiesIndexesKey)
            .get(forKeyPath: keyPath).fmap { $0.first ?? "" }
    }
    
    func save(data: CityData) -> Future<Bool> {
        let response = Future<Bool>()
        
        queue.async {
            self.index.bind { fileIndex -> Future<Bool> in
                var fileName = fileIndex
                if fileName.isEmpty {
                    fileName = data.getFileName()
                    _ = Indexes(for: FACache.citiesIndexesKey)
                        .save(forKeyPath: self.keyPath, value: fileName)
                }
                
                return self.service.get(forKey: fileName)
                    .bind { value -> Future<Bool> in
                        var citiesValue = value
                        if citiesValue.first(where: { $0.getKeyValue() == data.getKeyValue() }) == nil {
                            citiesValue.append(data)
                            return self.service.save(forKey: fileName)(citiesValue)
                        } else {
                            return Future<Bool>(value: true)
                        }
                }
                }.observe {
                    switch $0 {
                    case .success(let value):
                        response.resolve(with: value)
                    case .failure(let error):
                        response.reject(with: error)
                    }
            }
        }
        
        return response
    }
}
