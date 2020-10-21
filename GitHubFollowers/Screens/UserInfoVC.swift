//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/20/20.
//

import UIKit

class UserInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation
    */

}
