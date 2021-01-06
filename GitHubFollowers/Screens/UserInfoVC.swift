//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/20/20.
//

import UIKit

protocol UserInfoVCDelegate: class {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoVC: UIViewController {
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    var itemViews: [UIView] = []
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    var username: String!
    weak var delegate: FollowerListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // make network call and display data on screen
    func getUserInfo(){
        // use capture list [weak self] to fix potential memory leaks
        NetworkManager.shared.getUserInfo(for: username) { [weak self] (result) in
            // unwraping optional of self so we dont need optional values for each call of self
            // introduced in Swift 4.2
            guard let self = self else { return }
            switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.configureUIElements(with: user)
                    }
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureUIElements(with user: User){
        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.delegate = self
        
        let followerItemVC = GFFollowerItemVC(user: user)
        followerItemVC.delegate = self

        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since \(user.created_at.convertToDisplayFormat())"
    }
    
    // set UI constraints
    func layoutUI(){
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    // add a childVC to a containerView
    func add(childVC: UIViewController, to containerView: UIView){
        // add ViewController
        addChild(childVC)
        // add childVC to containerView
        containerView.addSubview(childVC.view)
        // fill up whole containerView
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }

}

extension UserInfoVC: UserInfoVCDelegate {
    // show safari view controller
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.html_url) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "the url attached to this user is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
    // dismiss VC and tell follower list screen the new user
    func didTapGetFollowers(for user: User) {
        // show alert if user has 0 followers
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No Followers", message: "This user has no followers", buttonTitle: "Ok")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
    
}
