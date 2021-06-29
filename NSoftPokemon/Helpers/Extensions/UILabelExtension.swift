//
//  UILabelExtension.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/28/21.
//

import Foundation
import UIKit

extension UILabel {
    static func newLabel(_ text: String?, _ isTitle: Bool?, _ color: UIColor?, _ textSize: CGFloat?) -> UILabel {
        let label = UILabel()
        if let text = text,
           let isTitle = isTitle,
           let color = color,
           let textSize = textSize {
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = text
            if isTitle {
                label.font = UIFont.boldSystemFont(ofSize: textSize)
            } else {
                label.font = UIFont.systemFont(ofSize: textSize)
            }
            label.textColor = color
        }
        return label
    }
}
