//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/20/20.
//

import UIKit

class UserInfoVC: UIViewController {

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton

        showLoadingView()
        // use capture list [weak self] to fix potential memory leaks
        NetworkManager.shared.getUserInfo(for: username) { [weak self] (result) in
            // unwraping optional of self so we dont need optional values for each call of self
            // introduced in Swift 4.2
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
                case .success(let username):
                    print(username)
                                    
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        
        }
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }

}
