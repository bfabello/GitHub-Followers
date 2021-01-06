//
//  GFRepoItemVC.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/27/20.
//
// Subclass of GFItemInfoVC to inherit all its capabilities

import UIKit

protocol GFRepoItemInfoVCDelegate: class {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC: GFItemInfoVC {
    
    // delegates must always be weak to avoid retain cycle
    weak var delegate: GFRepoItemInfoVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.public_repos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.public_gists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
