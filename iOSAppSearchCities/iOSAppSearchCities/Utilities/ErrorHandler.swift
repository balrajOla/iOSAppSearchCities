//
//  ErrorHandler.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 13/04/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import UIKit

class ErrorHandler {
  
  static func showErrorAlert(withMessage message: String, andRetryAction retryAction: (() -> Void)? = nil) {
    guard let visibleController = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.visibleViewController else {
      return
    }
    let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
    let cancelAlertAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    alertController.addAction(cancelAlertAction)
    if let action = retryAction {
      let retryAlertAction = UIAlertAction(title: "Retry", style: .default) { (_) in
        action()
      }
      alertController.addAction(retryAlertAction)
    }
    visibleController.present(alertController, animated: true, completion: nil)
  }
  
}
