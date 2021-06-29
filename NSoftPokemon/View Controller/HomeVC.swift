//
//  HomeVC.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/28/21.
//

import UIKit
import Network

class HomeVC: UIViewController, UIConfigurationProtocol {
    
    var tableView = UITableView()
    var username = ""
    
    var pokemons = PokemonsContainer() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let monitor = NWPathMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    internal func setupUI() {
        view.backgroundColor = .white
        setNavigation()
        setupTableView()
        addSubviews()
        setConstraints()
        setupTableView()
        
        getPokemonData()
        checkForInternetConnection { [weak self] status in
            guard let self = self else { return }
            if status == false {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "No Connection", message: "You are not connected to the internet.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    internal func setNavigation() {
        getUsernameFromKeychain()
        
        title = "Welcome \(username)"
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(favoritesButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .yellow
    }
    
    internal func addSubviews() {
        view.addSubview(tableView)
    }
    
    internal func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    internal func setupTableView() {
        setTableViewDelegates()
        tableView.backgroundColor = .tertiarySystemBackground
        tableView.rowHeight = 100.0
        tableView.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
        tableView.separatorStyle = .none
    }
    
    internal func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getUsernameFromKeychain() {
        if let username = KeychainWrapper.standard.string(forKey: "UsernameKeychain") {
            self.username = username
        }
    }
    
    private func checkForInternetConnection(completion: @escaping (Bool)->()) {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                debugPrint("Device is connected to the internet!")
                completion(true)
            } else {
                debugPrint("Device is not connected to the internet!")
                completion(false)
            }
            
            debugPrint("Connection is using Cellular data: \(path.isExpensive)")
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    @objc func favoritesButtonTapped() {
        navigationController?.pushViewController(FavoritesVC(), animated: true)
    }
}

extension HomeVC {
    private func getPokemonData() {
        Webservice.shared.getPokemons { result in
            switch result {
            case .success(let pokemons):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.pokemons = pokemons
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        tableView.reloadData()
    }
}

//MARK: - TableView delegate methods
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfRows = pokemons.results?.count {
            return numberOfRows
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell") as? PokemonCell else { return UITableViewCell() }
        cell.configureCell(pokemons.results?[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var vc = PokemonDetailsVC()
        vc.pokemonURL = pokemons.results?[indexPath.row].url ?? ""
        vc.pokemonName = pokemons.results?[indexPath.row].name ?? "No Name"
        navigationController?.pushViewController(vc, animated: true)
    }
}
