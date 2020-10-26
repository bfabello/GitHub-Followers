//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/20/20.
//

import UIKit

class UserInfoVC: UIViewController {
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    var itemViews: [UIView] = []
    
    var username: String!
    
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
    
    func getUserInfo(){
        // use capture list [weak self] to fix potential memory leaks
        NetworkManager.shared.getUserInfo(for: username) { [weak self] (result) in
            // unwraping optional of self so we dont need optional values for each call of self
            // introduced in Swift 4.2
            guard let self = self else { return }
            switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                    }
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func layoutUI(){
        itemViews = [headerView, itemViewOne, itemViewTwo]
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
        itemViewOne.backgroundColor = .systemTeal
        itemViewTwo.backgroundColor = .systemIndigo
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
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
