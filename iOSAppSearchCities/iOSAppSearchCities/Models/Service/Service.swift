//
//  Service.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 09/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case noDataToRead
    case writeDataIssue
}

protocol ServiceType {
    func searchCities(for keyword: String) -> Future<Cities>
    func save(forKey key: String) -> (_ data: [CityData]) -> Future<Bool>
    func get(forKey key: String) -> Future<[CityData]>
    func getAllCities() -> Future<[CityData]>
}

struct Service: ServiceType {
    let indexes: Indexes
    
    init(indexes: Indexes = Indexes(for: FACache.citiesIndexesKey)) {
        self.indexes = indexes
    }
    
    func searchCities(for keyword: String) -> Future<Cities> {
        let searchKeyPath = keyword.keyPath()
        return self.indexes.get(forKeyPath: searchKeyPath)  // find indexes
            .bind { values -> Future<Cities> in
                //get all files
                let totalIndexesCount = values.count
                
                return whenAll(values.map { fileName -> Future<[CityData]> in
                    self.get(forKey: fileName)
                }).fmap { $0.reduce([], +) }
                    .fmap { Cities(cities: $0) }
                    .fmap {
                        if totalIndexesCount > 0 {
                            return $0
                        } else {
                            return Cities(cityInfo: $0.info.filter { $0.key.starts(with: keyword) })
                        }
                }
        }
    }
    
    func save(forKey key: String)
        -> (_ data: [CityData])
        -> Future<Bool> {
            return { (data: [CityData]) -> Future<Bool> in
                let result = Future<Bool>()
                
                do {
                    try StorageHelper.store(data, to: StorageHelper.Directory.caches, as: "\(key).json")
                    result.resolve(with: true)
                } catch {
                    result.reject(with: ServiceError.writeDataIssue)
                }
                
                return result
            }
    }
    
    func get(forKey key: String) -> Future<[CityData]> {
        let result = Future<[CityData]>()
        
        guard let resultWritten = try? StorageHelper.retrieve("\(key).json", from: StorageHelper.Directory.caches, as: [CityData].self) else {
            result.resolve(with: [CityData]())
            return result
        }
        
        result.resolve(with: resultWritten)
        
        
        return result
    }
    
    func getAllCities() -> Future<[CityData]> {
        let result = Future<[CityData]>()
        
        
        guard let citiesDetail = try? (Bundle.main.path(forResource: "cities", ofType: "json")
            .flatMap { try Data(contentsOf: URL(fileURLWithPath: $0), options: .mappedIfSafe) }
            .flatMap { try JSONDecoder().decode([CityData].self, from: $0) }) else {
                result.reject(with: ServiceError.noDataToRead)
                return result
        }
        
        result.resolve(with: citiesDetail)
        
        
        return result
    }
    
    private func createUrl(forKey key: String) -> URL {
        return URL(fileURLWithPath: "/tmp/\(key).json")
    }
}
