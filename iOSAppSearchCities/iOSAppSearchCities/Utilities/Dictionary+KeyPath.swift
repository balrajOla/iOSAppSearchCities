//
//  Dictionary+KeyPath.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 10/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

public struct IndexKeyPath {
    var segments: [String]
    
    var isEmpty: Bool { return segments.isEmpty }
    var path: String {
        return segments.joined(separator: ".")
    }
    
    /// Strips off the first segment and returns a pair
    /// consisting of the first segment and the remaining key path.
    /// Returns nil if the key path has no segments.
    func headAndTail() -> (head: String, tail: IndexKeyPath)? {
        guard !isEmpty else { return nil }
        var tail = segments
        let head = tail.removeFirst()
        return (head, IndexKeyPath(segments: tail))
    }
}

/// Initializes a KeyPath with a string of the form "this.is.a.keypath"
extension IndexKeyPath {
    init(_ string: String) {
        segments = string.components(separatedBy: ".")
    }
}

extension IndexKeyPath: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
}

// Needed because Swift 3.0 doesn't support extensions with concrete
// same-type requirements (extension Dictionary where Key == String).
public protocol StringProtocol {
    init(string s: String)
}

extension String: StringProtocol {
    public init(string s: String) {
        self = s
    }
}


public extension Dictionary where Key: StringProtocol {
    subscript(indexKeyPath keyPath: IndexKeyPath) -> Any? {
        get {
            switch keyPath.headAndTail() {
            case nil:
                // key path is empty.
                return nil
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty:
                // Reached the end of the key path.
                let key = Key(string: head)
                switch self[key] {
                case let nestedDict as [Key: Any]:
                    // Next nest level is a dictionary.
                    // Start over with remaining key path.
                    let finalResult = nestedDict.keys
                        .compactMap { ($0 as? String).map { IndexKeyPath($0) } }
                        .compactMap { nestedDict[indexKeyPath: $0] }
                    
                    if let nestedArray = finalResult as? [[Any?]] {
                        return nestedArray.reduce([], +).compactMap{ $0 }
                    } else {
                        return finalResult
                    }
                    
                case let nextValue as Any:
                    // If there is any value then just return that value
                    return nextValue
                default:
                    // Next nest level isn't a dictionary.
                    // Invalid key path, abort.
                    return nil
                }
            case let (head, remainingKeyPath)?:
                // Key path has a tail we need to traverse.
                let key = Key(string: head)
                switch self[key] {
                case let nestedDict as [Key: Any]:
                    // Next nest level is a dictionary.
                    // Start over with remaining key path.
                    return nestedDict[indexKeyPath: remainingKeyPath]
                case let nextValue as Any:
                    // If there is any value then just return that value
                    return nextValue
                default:
                    // Next nest level isn't a dictionary.
                    // Invalid key path, abort.
                    return nil
                }
            }
        }
        set {
            switch keyPath.headAndTail() {
            case nil:
                // key path is empty.
                return
            case let (head, remainingKeyPath)? where remainingKeyPath.isEmpty:
                // Reached the end of the key path.
                let key = Key(string: head)
                self[key] = newValue as? Value
            case let (head, remainingKeyPath)?:
                let key = Key(string: head)
                let value = self[key]
                switch value {
                case var nestedDict as [Key: Any]:
                    // Key path has a tail we need to traverse
                    nestedDict[indexKeyPath: remainingKeyPath] = newValue
                    self[key] = nestedDict as? Value
                default:
                    // Store a new empty dictionary and continue
                    var nestedDict = [Key: Any]()
                    nestedDict[indexKeyPath: remainingKeyPath] = newValue
                    self[key] = nestedDict as? Value
                }
            }
        }
    }
}
