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
    lazy var baseExperienceLabel = UILabel.newLabel("Base experience: ", false, .black, 14)
    lazy var weightLabel = UILabel.newLabel("Weight: ", false, .black, 14)
    lazy var typesLabel = UILabel.newLabel("Types: ", false, .black, 14)
    lazy var addFavoritesButton = UIButton.newButton("Add to favorites", UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0))
    
    var pokemonURL = ""
    var pokemonName = ""
    var pokemonTypes = [String]()
    var pokemon = PokemonDetails() {
        didSet {
            print("PokemonDetailsVC \(pokemon)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    internal func setupUI() {
        setNavigation()
        addSubviews()
        setConstraints()
        
        getPokemonData {
            self.setUIElementsValue()
        }
    }
    
    func setNavigation() {
        title = pokemonName
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .red
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        view.backgroundColor = .tertiarySystemBackground
    }
    
    func addSubviews() {
        view.addSubview(detailsContainer)
        detailsContainer.addSubview(pokemonImage)
        detailsContainer.addSubview(divider)
        detailsContainer.addSubview(baseExperienceLabel)
        detailsContainer.addSubview(weightLabel)
        detailsContainer.addSubview(typesLabel)
        detailsContainer.addSubview(addFavoritesButton)
    }
    
    func setConstraints() {
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
    }
    
    private func setUIElementsValue() {
        if let imageUrl = pokemon.sprites?.front_default,
           let baseExperience = pokemon.base_experience,
           let weight = pokemon.weight {
            self.pokemonImage.sd_setImage(with: URL(string: imageUrl))
            self.baseExperienceLabel.text = "Base experience: \(baseExperience)"
            self.weightLabel.text = "Weight: \(weight)"
        }
        pokemon.types?.forEach({ type in
            pokemonTypes.append((type.type?.name?.uppercased())!)
        })
        let arr = pokemonTypes.map { (string) -> String in
            return String(string)
        }.joined(separator: "/")
        
        self.typesLabel.text = arr
    }
}

extension PokemonDetailsVC {
    private func getPokemonData(completion: @escaping ()->()) {
        Webservice.shared.getPokemonDetails(for: pokemonURL) { result in
            switch result {
            case .success(let pokemon):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.pokemon = pokemon
                    completion()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
