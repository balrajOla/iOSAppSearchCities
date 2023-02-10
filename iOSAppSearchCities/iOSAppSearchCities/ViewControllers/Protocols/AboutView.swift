//
//  AboutView.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 12/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

public protocol AboutView: class {
    func configure(with aboutInfo: AboutInfoData)
    func display(error: ModelError)
    func setActivityIndicator(hidden: Bool)
}

public protocol AboutPresenter {
    func loadAboutInfo()
    func aboutInfoDidLoad(aboutInfo: AboutInfoData)
    func aboutInfoDidFailLoading(error: ModelError)
}
