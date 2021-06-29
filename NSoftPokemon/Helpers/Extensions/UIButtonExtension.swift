//
//  UIButtonExtension.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/28/21.
//

import Foundation
import UIKit

extension UIButton {
    static func newButton(_ text: String?, _ color: UIColor?) -> UIButton {
        let button = UIButton(type: .system)
        if let text = text,
           let color = color {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(text, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.backgroundColor = color
            button.layer.cornerRadius = 6.0
            return button
        }
        return button
    }
}
