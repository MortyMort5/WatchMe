//
//  StaticFunctions.swift
//  WatchME
//
//  Created by Sterling Mortensen on 7/28/19.
//  Copyright © 2019 Sterling Mortensen. All rights reserved.
//

import UIKit

class StaticFunctions {
    static func showErrorAlert(viewController: UIViewController, errorTitle: String, errorMessage: String) {
        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAlertAction)
        viewController.present(alertController, animated: true)
    }
}
