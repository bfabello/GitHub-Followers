//
//  FollowerListVC.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/6/20.
//

import UIKit

class FollowerListVC: UIViewController {

    var userName: String!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers()
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated:true)
    }
    
    func configureCollectionView(){
        // fills up whole screen on view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColummnFlowLayout())
    
        // have to init CollectionView before adding it to subview
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemPink
        
        // register the cell
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func createThreeColummnFlowLayout() -> UICollectionViewFlowLayout {
        return UICollectionViewFlowLayout()
    }
    
    func getFollowers(){
        NetworkManager.shared.getFollowers(for: userName, page: 1) { (result) in
            
            switch result {
                case .success(let followers):
                    print(followers)
                
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}
