//
//  Future.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 09/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

class Future<Value> {
    fileprivate var result: Result<Value, Error>? {
        // Observe whenever a result is assigned, and report it
        didSet { result.map(report) }
    }
    private lazy var callbacks = [(Result<Value, Error>) -> Void]()
    
    init(value: Value? = nil) {
        // If the value was already known at the time the promise
        // was constructed, we can report the value directly
        result = value.map{ Result.success($0) }
    }

    func observe(with callback: @escaping (Result<Value, Error>) -> Void) {
        callbacks.append(callback)

        // If a result has already been set, call the callback directly
        result.map(callback)
    }

    func resolve(with value: Value) {
        result = .success(value)
    }
    
    func reject(with error: Error) {
        result = .failure(error)
    }
    
    private func report(result: Result<Value, Error>) {
        for callback in callbacks {
            callback(result)
        }
    }
}

extension Future {
    public static func pure<A>(_ a: A) -> Future<A> {
        return Future<A>(value: a)
    }

    public func bind<B>(_ m: @escaping (Value) throws -> Future<B>) -> Future<B> {
        let future = Future<B>()

        // Observe the current future
        observe { result in
            switch result {
            case .success(let value):
                do {
                    // Attempt to construct a new future given
                    // the value from the first one
                    let future = try m(value)

                    // Observe the "nested" future, and once it
                    // completes, resolve/reject the "wrapper" future
                    future.observe { result in
                        switch result {
                        case .success(let value):
                            future.resolve(with: value)
                        case .failure(let error):
                            future.reject(with: error)
                        }
                    }
                } catch {
                    future.reject(with: error)
                }
            case .failure(let error):
                future.reject(with: error)
            }
        }

        return future
    }
}


extension Future {
    public func fmap<B>(_ transform: @escaping (Value) throws -> B) -> Future<B> {
        return bind { value in
            return try Future<B>(value: transform(value))
        }
    }
}


func whenAll<T>(_ futures: [Future<T>]) -> Future<[T]> {
    let futureResponse = Future<[T]>()
    var successRes: [T] = [T]()
    var failRes: Error?
    let dispatchGroup = DispatchGroup()
    
    futures.forEach {
        dispatchGroup.enter()
        
        $0.observe(with: { response in
            switch response {
            case .success(let val):
                successRes.append(val)
            case .failure(let error):
                failRes = error
            }
            dispatchGroup.leave()
        })
    }
    
    dispatchGroup.notify(queue: .global(qos: .utility)) {
        if let err = failRes {
            futureResponse.reject(with: err)
        } else {
            futureResponse.resolve(with: successRes)
        }
    }
    
    return futureResponse
}

