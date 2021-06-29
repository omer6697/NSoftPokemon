//
//  UIViewExtension.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/29/21.
//

import UIKit

extension UIView {
    static func newDivider() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }
}
