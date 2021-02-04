//
//  FavoritesIndexTableViewController.swift
//  PokeApp
//
//  Created by Vitor Campos on 2/4/21.
//

import UIKit
import FittedSheets

class FavoritesIndexTableViewController: UITableViewController {
    
    let viewModel = FavoritesIndexViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        viewModel.notifyViewController = {
            self.tableView.reloadData()
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPokemons()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell!.textLabel?.text = viewModel.pokemonName(at: indexPath.row)
        cell!.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.viewModel(at: indexPath.row) { detailsViewModel in
            DispatchQueue.main.async {
                tableView.deselectRow(at: indexPath, animated: true)
                let controller = PokemonDetailsViewController()
                controller.viewModel = detailsViewModel
                let options = SheetOptions(shrinkPresentingViewController: false)
                let sheet = SheetViewController(controller: controller, sizes: [.fixed(450)], options: options)
                self.present(sheet, animated: true, completion: nil)
            }
        }
    }

}
