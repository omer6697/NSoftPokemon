//
//  UIAlertController.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/28/21.
//

import UIKit

extension UIAlertController {
    static func showCustomAlert(for viewController: UIViewController, title: String?, message: String?, actionTitle: String?) {
        if let title = title,
           let message = message,
           let actionTitle = actionTitle {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
