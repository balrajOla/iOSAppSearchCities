//
//  StorageHelper.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 10/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

class StorageHelper{
    
    //MARK: - Variables
    enum StorageHelperError:Error{
        case error(_ message:String)
    }
    
    enum Directory {
        // Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory and will be automatically backed up by iCloud.
        case documents
        
        // Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
        case caches
    }
    
    
    
    //MARK: - Functions
    /** Store an encodable struct to the specified directory on disk
     *  @param object      The encodable struct to store
     *  @param directory   Where to store the struct
     *  @param fileName    What to name the file where the struct data will be stored
     **/
    static func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: String) throws {
        
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        }
        catch {
            throw(error)
        }
        
    }
    
    /** Retrieve and convert an Object from a file on disk
     *  @param fileName    Name of the file where struct data is stored
     *  @param directory   Directory where Object data is stored
     *  @param type        Object type (i.e. Message.self)
     *  @return decoded    Object model(s) of data
     **/
    static func retrieve<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) throws -> T{
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            throw StorageHelperError.error("No data at location: \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                throw(error)
            }
        }
        else {
            throw StorageHelperError.error("No data at location: \(url.path)")
        }
    }
    
    /** Remove all files at specified directory **/
    static func clear(_ directory: Directory) throws {
        
        let url = getURL(for: directory)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        }
        catch {
            throw(error)
        }
        
    }
    
    /** Remove specified file from specified directory **/
    static func remove(_ fileName: String, from directory: Directory) throws {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                throw(error)
            }
        }
    }
    
    
    //MARK: Helpers
    /** Returns BOOL indicating whether file exists at specified directory with specified file name **/
    static fileprivate func fileExists(_ fileName: String, in directory: Directory) -> Bool {
        
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        
        return FileManager.default.fileExists(atPath: url.path)
        
    }
    
    /** Returns URL constructed from specified directory **/
    static fileprivate func getURL(for directory: Directory) -> URL {
        
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        }
        
        if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
        
    }
    
}
