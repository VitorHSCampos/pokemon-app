//
//  FavoritesIndexViewModel.swift
//  PokeApp
//
//  Created by Vitor Campos on 2/4/21.
//

import Foundation
import RealmSwift

class FavoritesIndexViewModel{
    
    let pokemonList = Pokemon.listAllFavorites()
    
    var notifyViewController: (() -> ())?
    var tokenObserver: NotificationToken?
    
    
    init() {
        self.tokenObserver = pokemonList.observe {  _ in
            self.notifyViewController?()
        }
    }
    
    deinit {
        tokenObserver?.invalidate()
    }
    
    func numberOfPokemons() -> Int {
        return pokemonList.count
    }
    
    func pokemonName(at index: Int) -> String {
        return pokemonList[index].name.capitalized
    }
    
    func viewModel(at index: Int, completion: @escaping (PokemonDetailsViewModel) -> ()) {
        let vm = PokemonDetailsViewModel(with: pokemonList[index].detachedCopy())
        completion(vm)
    }
}
