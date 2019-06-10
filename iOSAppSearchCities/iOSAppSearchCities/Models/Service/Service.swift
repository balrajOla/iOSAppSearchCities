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
    func searchCities(for keyword: String) -> Future<CityData>?
}

struct Service: ServiceType {
    func searchCities(for keyword: String) -> Future<CityData>? {
        return nil
    }
    
    func save(forKey key: String)
        -> (_ data: [CityData])
        -> Future<Bool> {
            return { (data: [CityData]) -> Future<Bool> in
                let result = Future<Bool>()
                
                DispatchQueue.global(qos: .utility).async {
                    do {
                        try StorageHelper.store(data, to: StorageHelper.Directory.documents, as: "\(key).json")
                    } catch {
                        result.reject(with: ServiceError.writeDataIssue)
                    }
                }
                return result
            }
    }
    
    func get(forKey key: String) -> Future<[CityData]> {
        let result = Future<[CityData]>()
        
        DispatchQueue.global(qos: .utility).async {
            guard let resultWritten = try? StorageHelper.retrieve("\(key).json", from: StorageHelper.Directory.documents, as: [CityData].self) else {
                result.reject(with: ServiceError.noDataToRead)
                return
            }
            
            result.resolve(with: resultWritten)
        }
        
        return result
    }
    
    private func createUrl(forKey key: String) -> URL {
        return URL(fileURLWithPath: "/tmp/\(key).json")
    }
}
