//
//  AboutModel.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 12/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation
public protocol AboutModel {
    var aboutInfo: AboutInfo? { get set }
    func loadAboutInfo(with presenter: AboutPresenter)
}

// MARK: - Model class implementation

public class Model: NSObject, AboutModel {
    public var aboutInfo: AboutInfo?
    
    public override init() {
        super.init()
    }
    
    public func loadAboutInfo(with presenter: AboutPresenter) {
        guard
            let info = self.aboutInfo
            else {
                presenter.aboutInfoDidFailLoading(error: ModelError.failedLoading)
                return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            presenter.aboutInfoDidLoad(aboutInfo: info)
        }
    }
}

// MARK: - Custom ModelError object

public enum ModelError: Error {
    case failedLoading
}

extension ModelError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedLoading: return "Failed to load About information."
        }
    }
}
