//
//  FollowerListVC.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/6/20.
//
 
import UIKit

class FollowerListVC: UIViewController {
    
    enum Section{
        case main
    }
    
    var userName: String!
    var followers: [Follower] = []
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers()
        configureDataSource()
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
    
        // have to init CollectionView before adding it to subview
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        
        // register the cell
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func getFollowers(){
        NetworkManager.shared.getFollowers(for: userName, page: 1) { [weak self] (result) in
            // use capture list [weak self] to fix potential memory leaks
            // unwraping optional of self so we dont need optional values for each call of self
            // introduced in Swift 4.2
            guard let self = self else { return }
            
            switch result {
                case .success(let followers):
                    self.followers = followers
                    self.updateData()
                
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    // real time updating snapshot
    func updateData(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
