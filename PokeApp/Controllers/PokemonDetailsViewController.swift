//
//  PokemonDetailsViewController.swift
//  PokeApp
//
//  Created by Vitor Campos on 2/4/21.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hpValue: UILabel!
    @IBOutlet weak var speedValue: UILabel!
    @IBOutlet weak var defenseValue: UILabel!
    @IBOutlet weak var attackValue: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var viewModel: PokemonDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.name.text = viewModel.pokemonName()
        self.hpValue.text = viewModel.pokemonHp()
        self.speedValue.text = viewModel.pokemonSpeed()
        self.defenseValue.text = viewModel.pokemonDefense()
        self.attackValue.text = viewModel.pokemonAttack()
        
        self.favoriteButton.layer.cornerRadius = favoriteButton.frame.height/2
        self.favoriteButton.clipsToBounds = true
        self.favoriteButton.setTitleColor(.white, for: .normal)
        
        if viewModel.isPokemonFavorite() {
            self.favoriteButton.setTitle("Remover dos favoritos", for: .normal)
            self.favoriteButton.backgroundColor = .systemGray
        } else {
            self.favoriteButton.setTitle("Adicionar aos favoritos", for: .normal)
            self.favoriteButton.backgroundColor = .systemGreen
        }
        
        self.favoriteButton.addTarget(self, action: #selector(tappedFavButton), for: .touchUpInside)
        
        viewModel.downloadPokemonImage { (imageData) in
            DispatchQueue.main.async {
                self.image.image = UIImage(data: imageData)
            }
        }
    }
    
    @objc func tappedFavButton() {
        self.viewModel.toggleFavorite()
        
        if viewModel.isPokemonFavorite() {
            self.favoriteButton.setTitle("Remover dos favoritos", for: .normal)
            self.favoriteButton.backgroundColor = .systemGray
        } else {
            self.favoriteButton.setTitle("Adicionar aos faoritos", for: .normal)
            self.favoriteButton.backgroundColor = .systemGreen
        }
    }
}
