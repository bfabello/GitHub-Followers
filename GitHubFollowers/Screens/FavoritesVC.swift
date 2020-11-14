//
//  FavoritesVC.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/2/20.
//

import UIKit

class FavoritesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        PersistenceManager.retrieveFavorites { result in
            switch result{
                case .success(let favorites):
                    print(favorites)
                case .failure(let error):
                    break
            }
        }
    }

}
