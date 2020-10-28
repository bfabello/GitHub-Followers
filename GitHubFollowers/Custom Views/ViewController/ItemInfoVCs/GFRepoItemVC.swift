//
//  GFRepoItemVC.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/27/20.
//
// Subclass of GFItemInfoVC to inherit all its capabilities

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.public_repos)
        itemInfoViewOne.set(itemInfoType: .gists, withCount: user.public_gists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
}
