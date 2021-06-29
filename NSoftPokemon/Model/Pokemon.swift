//
//  Pokemon.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/29/21.
//

import Foundation

struct PokemonsContainer: Decodable {
    var results: [Pokemon]?
}

struct Pokemon: Decodable {
    var name: String?
    var url: String?
}

struct PokemonDetails: Decodable {
    var base_experience: Int?
    var sprites: PokemonSprites?
    var types: [PokemonType]?
    var weight: Int?
}

struct PokemonSprites: Decodable {
    var front_default: String?
}

struct PokemonType: Decodable {
    var type: PokeType?
}

struct PokeType: Decodable {
    var name: String?
}
