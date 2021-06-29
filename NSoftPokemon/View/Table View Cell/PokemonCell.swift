//
//  PokemonCell.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/29/21.
//

import UIKit

class PokemonCell: UITableViewCell {
    
    lazy var cellContainer = UIView()
    lazy var titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        
        addSubview(cellContainer)
        addSubview(titleLabel)
        
        configureUI()
        setUIConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PokemonCell {
    internal func configureCell(_ title: String?) {
        if let title = title {
            self.titleLabel.text = title
        }
    }
    
    private func configureUI() {
        cellContainer.backgroundColor = UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0)
        cellContainer.layer.cornerRadius = 10.0
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        
        
    }
    
    private func setUIConstraints() {
        cellContainer.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellContainer.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cellContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            cellContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cellContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            titleLabel.centerYAnchor.constraint(equalTo: cellContainer.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: cellContainer.centerXAnchor)
        ])
    }
}
