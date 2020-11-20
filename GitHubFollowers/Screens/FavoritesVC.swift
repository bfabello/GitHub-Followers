//
//  FavoritesVC.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/2/20.
//

import UIKit

class FavoritesVC: UIViewController {

    let tableView = UITableView()
    var favorites: [Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    // viewDidLoad can only get called once
    // will get called if theres empty state first then adds a favorite
    // make sure we constantly refresh favorites
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
        
    }
    
    func getFavorites(){
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result{
                case .success(let favorites):
                    if favorites.isEmpty {
                        self.showEmptyStateView(with: "You have no Favorites.\nAdd one on the follower screen", in: self.view)
                    } else {
                        self.favorites = favorites
                        // pull our newly populated favorites list and populate the table view
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            // if we have an empty state first and added a favorite then came back
                            self.view.bringSubviewToFront(self.tableView)
                        }
                    }
                    
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    // Data Source
    // Number of rows is how many favorites we have
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    // will get called everytime a cell shows on screen
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    
}
