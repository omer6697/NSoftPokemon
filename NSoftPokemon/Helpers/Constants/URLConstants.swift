//
//  URLConstants.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/29/21.
//

import Foundation

struct URLContants {
    static let shared = URLContants()
    
    private init() { }
    
    internal func getBasePokemonURL() -> String {
        return "https://pokeapi.co/api/v2/pokemon"
    }
    
    internal func getPokemonDetailsURL(for id: Int?) -> String {
        return "https://pokeapi.co/api/v2/pokemon/\(String(describing: id))/"
    }
}
