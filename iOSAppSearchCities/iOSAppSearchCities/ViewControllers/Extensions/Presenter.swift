//
//  Presenter.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 12/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

public final class Presenter: AboutPresenter {
    private weak var view: AboutView?
    private let model: AboutModel
    
    public init(view: AboutView?, model: AboutModel) {
        self.view = view
        self.model = model
    }
    
    public func loadAboutInfo() {
        self.view?.setActivityIndicator(hidden: false)
        self.model.loadAboutInfo(with: self)
    }
    
    public func aboutInfoDidLoad(aboutInfo: AboutInfoData) {
        self.view?.setActivityIndicator(hidden: true)
        self.view?.configure(with: aboutInfo)
    }
    
    public func aboutInfoDidFailLoading(error: ModelError) {
        self.view?.setActivityIndicator(hidden: true)
        self.view?.display(error: error)
    }
}
