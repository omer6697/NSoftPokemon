//
//  PokemonCD+CoreDataProperties.swift
//  NSoftPokemon
//
//  Created by Omer Rahmanovic on 6/30/21.
//
//

import Foundation
import CoreData


extension PokemonCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonCD> {
        return NSFetchRequest<PokemonCD>(entityName: "PokemonCD")
    }

    @NSManaged public var baseExperience: Int16
    @NSManaged public var imageURL: String?
    @NSManaged public var types: String?
    @NSManaged public var weight: Int16
    @NSManaged public var name: String?

}

extension PokemonCD : Identifiable {

}
