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
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(userName: String) {
        super.init(nibName: nil, bundle: nil)
        self.userName = userName
        title = userName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
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
        
        searchController.searchBar.placeholder = "Search for a username"
        
        // doesnt make screen semi transparent when search bar is clicked
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
    }
    
    func getFollowers(username: String, page: Int){
        showLoadingView()
        isLoadingMoreFollowers = true
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
            self.isLoadingMoreFollowers = false
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
    
    @objc func addButtonTapped(){
        showLoadingView()
        // use capture list [weak self] to fix potential memory leaks
        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
            // unwraping optional of self so we dont need optional values for each call of self
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
                case .success(let user):
                    // create Follower object
                    let favorite = Follower(login: user.login, avatar_url: user.avatar_url)
                    // add favorite Follower object to persistance manager
                    PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                        guard let self = self else { return }
                        // if error was nil our save was good 
                        guard let error = error  else {
                            self.presentGFAlertOnMainThread(title: "Success!", message: "You have sucessfully added user to your favorites", buttonTitle: "Ok")
                            return
                        }
                        // if not nil something went bad
                        self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                    }
                // presenting failure case
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
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
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: userName, page: page)
            
        }
    }
    
    // listening to what item the user taps on
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // turnary operator - WTF = What ? True : False
        // clean to use for basic if else statements
        // 
        let activeArray = isSearching ? filteredFollowers : followers
        
        // get specific follower from array with indexPath
        let follower = activeArray[indexPath.item]
        let destinationVC = UserInfoVC()
        destinationVC.username = follower.login
        destinationVC.delegate = self
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
}

// Search Delegates
extension FollowerListVC: UISearchResultsUpdating {
    
    // listening when user types in search bar
    func updateSearchResults(for searchController: UISearchController) {
        // make sure there is text in search bar
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        // $0 - represents the item
        // login.lowercased() - so caseing does not matter
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

// Follower List VC Delegates
extension FollowerListVC: UserInfoListVCDelegate {
    // get followers for that user
    func didRequestFollowers(for username: String) {
        // reset screen and set username
        self.userName = username
        title = username
        // clear arrays of followers and filtered followers
        followers.removeAll()
        filteredFollowers.removeAll()
        // reset page back to first page
        page = 1
        // scroll collection view all the way to the top
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        // call getFollowers to make network call
        getFollowers(username: username, page: page)
    }
}
