//
//  PokemonDetailsVC.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/29/21.
//

import UIKit
import SDWebImage

class PokemonDetailsVC: UIViewController, UIConfigurationProtocol {

    lazy var detailsContainer = UIView()
    lazy var pokemonImage = SDAnimatedImageView()
    lazy var divider = UIView.newDivider()
    lazy var baseExperienceLabel = UILabel.newLabel(SBString.pds_base_experience, false, .black, 14)
    lazy var weightLabel = UILabel.newLabel(SBString.pds_weight, false, .black, 14)
    lazy var typesLabel = UILabel.newLabel(SBString.pds_types, false, .black, 14)
    lazy var addFavoritesButton = UIButton.newButton(SBString.pds_button_title, UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0))
    
    var viewModel = PokemonDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    internal func setupUI() {
        setNavigation()
        addSubviews()
        setConstraints()
        
        viewModel.getPokemonData {
            self.setUIElementsValue()
        }
    }
    
    internal func setNavigation() {
        title = viewModel.pokemonName
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: SBString.back_button, style: .plain, target: nil, action: nil)
        view.backgroundColor = .tertiarySystemBackground
    }
    
    internal func addSubviews() {
        view.addSubview(detailsContainer)
        detailsContainer.addSubview(pokemonImage)
        detailsContainer.addSubview(divider)
        detailsContainer.addSubview(baseExperienceLabel)
        detailsContainer.addSubview(weightLabel)
        detailsContainer.addSubview(typesLabel)
        detailsContainer.addSubview(addFavoritesButton)
    }
    
    internal func setConstraints() {
        detailsContainer.translatesAutoresizingMaskIntoConstraints = false
        pokemonImage.translatesAutoresizingMaskIntoConstraints = false
        divider.translatesAutoresizingMaskIntoConstraints = false
        baseExperienceLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        typesLabel.translatesAutoresizingMaskIntoConstraints = false
        addFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        addFavoritesButton.setTitleColor(.black, for: .normal)
        
        NSLayoutConstraint.activate([
            detailsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            detailsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            
            pokemonImage.topAnchor.constraint(equalTo: detailsContainer.topAnchor, constant: 20),
            pokemonImage.centerXAnchor.constraint(equalTo: detailsContainer.centerXAnchor),
            pokemonImage.widthAnchor.constraint(equalToConstant: 120),
            pokemonImage.heightAnchor.constraint(equalToConstant: 120),
            
            divider.topAnchor.constraint(equalTo: pokemonImage.bottomAnchor, constant: 20),
            divider.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -20),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            baseExperienceLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 20),
            baseExperienceLabel.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 20),
            baseExperienceLabel.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -20),
            
            weightLabel.topAnchor.constraint(equalTo: baseExperienceLabel.bottomAnchor, constant: 20),
            weightLabel.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 20),
            weightLabel.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -20),
            
            typesLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 20),
            typesLabel.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 20),
            typesLabel.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -20),
            
            addFavoritesButton.bottomAnchor.constraint(equalTo: detailsContainer.bottomAnchor, constant: -40),
            addFavoritesButton.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 60),
            addFavoritesButton.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -60),
            addFavoritesButton.heightAnchor.constraint(equalToConstant: 50.0),
        ])
        
        addButtonAction()
    }
    
    internal func addButtonAction() {
        addFavoritesButton.addTarget(self, action: #selector(addToFavoritesTapped), for: .touchUpInside)
    }
    
    private func setUIElementsValue() {
        if let imageUrl = viewModel.pokemon.sprites?.front_default,
           let baseExperience = viewModel.pokemon.base_experience,
           let weight = viewModel.pokemon.weight {
            self.pokemonImage.sd_setImage(with: URL(string: imageUrl))
            self.baseExperienceLabel.text = "\(SBString.pds_base_experience) \(baseExperience)"
            self.weightLabel.text = "\(SBString.pds_weight) \(weight)"
        }
        viewModel.pokemon.types?.forEach({ type in
            viewModel.pokemonTypes.append((type.type?.name?.uppercased())!)
        })
        viewModel.arr = viewModel.pokemonTypes.map { (string) -> String in
            return String(string)
        }.joined(separator: "/")
        
        self.typesLabel.text = "\(SBString.pds_types) \(viewModel.arr)"
    }
    
    @objc func addToFavoritesTapped() {
        viewModel.addFavoritesTapped()
        showCustomAlert(title: SBString.alert_title_success, message: (viewModel.pokemonName) + SBString.alert_message_added_fav, actionTitle: SBString.alert_action_ok)
    }
    
    private func showCustomAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
