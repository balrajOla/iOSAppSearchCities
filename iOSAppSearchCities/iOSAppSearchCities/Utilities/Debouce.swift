//
//  Debouce.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 11/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation
extension OperationQueue {
    
    /// Creates a debounced function that delays invoking `action` until after `delay` seconds have elapsed since the last time the debounced function was invoked.
    ///
    /// - Parameters:
    ///   - delay: The number of seconds to delay.
    ///   - underlyingQueue: An optional background queue to run the function
    ///   - action: The function to debounce.
    /// - Returns: Returns the new debounced function.
    class func debounce<T, R>(delay: TimeInterval, underlyingQueue: DispatchQueue? = nil, action: @escaping (T) -> Future<R>) -> ((T) -> Future<R>) {
        // Init a new serial queue
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.underlyingQueue = underlyingQueue
        
        let sleepOpName = "__SleepOp"   // Sleep operation name
        let actionOpName = "__ActionOp" // Action operation name
        
        
        return { (value: T) -> Future<R> in
            let response = Future<R>()
            
            // Check if the first not cancelled or finished operation is executing
            var isExecuting = false
            for op in queue.operations {
                if op.isFinished || op.isCancelled {
                    continue
                }
                
                isExecuting = op.isExecuting && op.name == actionOpName
                break
            }
            
            if !isExecuting {
                queue.cancelAllOperations()
            }
            
            let sleepOp = BlockOperation(block: {
                Thread.sleep(forTimeInterval: delay)
            })
            sleepOp.name = sleepOpName
            
            let actionOp = BlockOperation(block: {
                action(value).observe {
                    switch $0 {
                    case .success(let value):
                        response.resolve(with: value)
                    case .failure(let error):
                        response.reject(with: error)
                    }
                }
            })
            
            actionOp.name = actionOpName
            
            queue.addOperation(sleepOp)
            queue.addOperation(actionOp)
            
            return response
        }
    }
}
