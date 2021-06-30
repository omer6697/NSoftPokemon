//
//  CoreDataService.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/30/21.
//

import UIKit
import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    
    private init() { }
    
    func savePokemonCDData(name: String?, imageUrl: String?, baseExperience: Int?, weight: Int?, types: String?) {
        if let name = name,
           let imageUrl = imageUrl,
           let baseExperience = baseExperience,
           let weight = weight,
           let types = types {
            let pokemonCD = PokemonCD(context: PersistanceService.context)
            pokemonCD.name = name
            pokemonCD.imageURL = imageUrl
            pokemonCD.baseExperience = Int16(baseExperience)
            pokemonCD.weight = Int16(weight)
            pokemonCD.types = types
            
            PersistanceService.saveContext()
        }
    }
    
    func fetchPokemonCDData(completion: @escaping ([PokemonCD]) ->()) {
        var data = [PokemonCD]()
        let fetchRequest: NSFetchRequest<PokemonCD> = PokemonCD.fetchRequest()
        do {
            let pokemons = try PersistanceService.context.fetch(fetchRequest)
            data = pokemons
            completion(data)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
