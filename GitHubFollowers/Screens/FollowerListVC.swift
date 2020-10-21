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
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: userName, page: page)
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
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        // register the cell
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureSearchController(){
        let searchController = UISearchController()
        
        // conform to UISearchResultsUpdating protocol
        searchController.searchResultsUpdater = self
        
        // conform to protocol UISearchBarDelegate
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        
        // doesnt make screen semi transparent when search bar is clicked
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
    }
    
    func getFollowers(username: String, page: Int){
        showLoadingView()
        // use capture list [weak self] to fix potential memory leaks
        NetworkManager.shared.getFollowers(for: userName, page: page) { [weak self] (result) in
            // unwraping optional of self so we dont need optional values for each call of self
            // introduced in Swift 4.2
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
                case .success(let followers):
                    // if followers < 100 switch hasMoreFollowers flag to false
                    // append new followers to array
                    if followers.count < 100 { self.hasMoreFollowers = false }
                    self.followers.append(contentsOf: followers)
                    
                    // if followers array is empty show message and return
                    if self.followers.isEmpty {
                        let message = "This user does not have any followers ☹️"
                        DispatchQueue.main.async {
                            self.showEmptyStateView(with: message, in: self.view)
                        }
                        return
                    }
                    self.updateData(on: self.followers)
                
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
    func updateData(on followers: [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - Extensions

// UICollectionView Delegates
extension FollowerListVC: UICollectionViewDelegate {
    
    // listening for when user scrolls all the way to the bottom of screen
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // coordinates of how far you scroll down
        let offsetY = scrollView.contentOffset.y
        // height of entire scroll view with followers
        let contentHeight = scrollView.contentSize.height
        // height of screen
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: userName, page: page)
            
        }
    }
    
    // listening to what item the user taps on
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // turnary operator - WTF = What ? True : False
        // clean to use for basic if else statements
        let activeArray = isSearching ? filteredFollowers : followers
        
        // get specific follower from array with indexPath
        let follower = activeArray[indexPath.item]
        let destinationVC = UserInfoVC()
        destinationVC.username = follower.login
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
}

// Search Delegates
extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    // listening when user types in search bar
    func updateSearchResults(for searchController: UISearchController) {
        // make sure there is text in search bar
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        // $0 - represents the item
        // login.lowercased() - so caseing does not matter
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
    
    // listening when user clicks cancel button on search bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // can use .toggle() for Bool
        isSearching = false
        updateData(on: followers)
    }
}

