//
//  HomeViewModel.swift
//  NSoftPokemon
//
//  Created by OMERS on 4. 8. 2021..
//

import Foundation
import Network

class HomeViewModel {
    var username = ""
    let monitor = NWPathMonitor()
    
    internal func checkForNetwork(completion: @escaping (Bool)->()) {
        monitor.pathUpdateHandler = { path in
            switch path.status {
            case .satisfied:
                debugPrint("Device is connected!")
                completion(true)
            case .requiresConnection:
                debugPrint("You are not connected!")
                completion(false)
            case .unsatisfied:
                debugPrint("Device is not connected!")
                completion(false)
            }
        }
    }
    
    internal func getPokemonData() {
        
    }
    
    internal func getUsernameFromKeychain() {
        
    }
}
