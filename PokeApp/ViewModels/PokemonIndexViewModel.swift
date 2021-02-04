//
//  PokemonIndexViewModel.swift
//  PokeApp
//
//  Created by Vitor Campos on 2/4/21.
//

import Foundation

class PokemonIndexViewModel {

    private let pokemonService = PokemonService()
    private var pokemons: [PokemonIndex] = [] {
        didSet {
            filteredPokemons = pokemons
            DispatchQueue.main.async {
                self.notifyViewController?()
            }
        }
    }
    
    private var filteredPokemons: [PokemonIndex] = []

    var notifyViewController: (() -> ())?

    init() {
        refreshPokemonList()
    }

    func refreshPokemonList() {
        pokemonService.getPokemonList { (pokemons) in
            self.pokemons = pokemons.sorted(by: { (poke1, poke2) -> Bool in
                return poke1.name < poke2.name
            })
        }
    }

    func numberOfPokemons() -> Int {
        return self.filteredPokemons.count
    }

    func pokemonName(at index: Int) -> String {
        return filteredPokemons[index].name.capitalized
    }
    
    func filter(using text: String?) {
        guard let text = text, text != "" else {
            self.filteredPokemons = pokemons
            notifyViewController?()
            return
        }
        
        self.filteredPokemons = self.pokemons.filter({ (pokemon) -> Bool in
            return pokemon.name.lowercased().contains(text.lowercased())
        })
        
        notifyViewController?()
    }
    
    func viewModel(at index: Int, completion: @escaping (PokemonDetailsViewModel) -> ()) {
        let pokemonName = filteredPokemons[index].name
        pokemonService.getPokemon(by: pokemonName) { (pokemon) in
            let vm = PokemonDetailsViewModel(with: pokemon.detachedCopy())
            completion(vm)
        }
    }
}
