//
//  FavoritesVC.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/29/21.
//

import Foundation
import UIKit

class FavoritesVC: UIViewController, UIConfigurationProtocol {
    
    var tableView = UITableView()
    var pokemons = [PokemonCD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        
        fetchFromCoreData()
        pokemons.forEach { pokemon in
            print(pokemon.name ?? "No name")
            print(pokemon.imageURL!)
            print(pokemon.baseExperience)
            print(pokemon.weight)
            print(pokemon.types!)
        }
    }
    
    func setupUI() {
        setNavigation()
        addSubviews()
    }
    
    func setNavigation() {
        title = "Favorites"
        view.backgroundColor = .tertiarySystemBackground
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    func addSubviews() {
        view.addSubview(tableView)
        setConstraints()
    }
    
    func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        setTableViewDelegates()
        tableView.backgroundColor = .tertiarySystemBackground
        tableView.rowHeight = 100.0
        tableView.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
        tableView.separatorStyle = .none
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchFromCoreData() {
        CoreDataService.shared.fetchPokemonCDData { [weak self] pokemons in
            guard let self = self else { return }
            self.pokemons = pokemons
        }
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell") as? PokemonCell else { return UITableViewCell() }
        cell.configureCell(pokemons[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pokemon = pokemons[indexPath.row]
            PersistanceService.context.delete(pokemon)
            PersistanceService.saveContext()
            
            pokemons.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
