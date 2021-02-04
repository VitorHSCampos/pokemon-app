//
//  PokemonDetailsViewModel.swift
//  PokeApp
//
//  Created by Vitor Campos on 2/4/21.
//

import Foundation

class PokemonDetailsViewModel {
    
    private let pokemon: Pokemon!
    
    init(with pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    func pokemonName() -> String {
        return pokemon.name.capitalized
    }
    
    func downloadPokemonImage(completion: @escaping (Data) -> ()) {
        if let url = URL(string: pokemon.image) {
            DispatchQueue.global(qos: .userInteractive).async {
                let data = try? Data(contentsOf: url)
                if let data = data {
                    completion(data)
                }
            }
        }
    }
    
    func pokemonHp() -> String {
        return "\(pokemon.hp)"
    }
    
    func pokemonAttack() -> String {
        return "\(pokemon.attack)"
    }
    
    func pokemonDefense() -> String {
        return "\(pokemon.defense)"
    }
    
    func pokemonSpeed() -> String {
        return "\(pokemon.speed)"
    }
    
    func isPokemonFavorite() -> Bool {
        return pokemon.isFavorite()
    }
    
    func toggleFavorite() {
        if pokemon.isFavorite() {
            pokemon.removeFavorite()
        } else {
            pokemon.favorite()
        }
    }
}
