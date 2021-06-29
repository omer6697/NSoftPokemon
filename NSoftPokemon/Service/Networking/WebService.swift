//
//  WebService.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/29/21.
//

import UIKit

final class Webservice {
    static let shared = Webservice()
    
    private init() { }
    
    func getPokemons(completion: @escaping (Result<PokemonsContainer, Error>) -> ()) {
        guard let url = URL(string: URLContants.shared.getBasePokemonURL()) else {
            print("Invalid URL"); return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let content = try! JSONDecoder().decode(PokemonsContainer.self, from: data!)
                completion(.success(content))
            }
        }.resume()
    }
    
    func getPokemonDetails(for pokemonURL: String, completion: @escaping (Result<PokemonDetails, Error>) -> ()) {
        guard let url = URL(string: pokemonURL) else {
            print("Invalid URL"); return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let content = try! JSONDecoder().decode(PokemonDetails.self, from: data!)
                completion(.success(content))
            }
        }.resume()
    }
}
