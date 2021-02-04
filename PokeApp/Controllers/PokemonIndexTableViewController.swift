//
//  PokemonIndexTableViewController.swift
//  PokeApp
//
//  Created by Vitor Campos on 2/4/21.
//

import UIKit
import FittedSheets

class PokemonIndexTableViewController: UITableViewController, UISearchResultsUpdating {
  
    private let viewModel = PokemonIndexViewModel()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.notifyViewController = {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        
        self.title = "Pokemon Index"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
        
    @objc func refreshContent() {
        self.viewModel.refreshPokemonList()
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
    
    // MARK: - SearchController 
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filter(using: searchController.searchBar.text)
    }
}
