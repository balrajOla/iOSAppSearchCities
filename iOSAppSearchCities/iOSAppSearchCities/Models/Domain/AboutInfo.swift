//
//  AboutInfo.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 12/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

public protocol AboutInfoData {
    var country: String { get }
    var city: String  { get }
    var lat: String { get }
    var long: String { get }
}

// MARK: - AboutInfo object

public struct AboutInfo: Codable, AboutInfoData {
    public let country: String
    public let city: String
    public let lat: String
    public let long: String
}
