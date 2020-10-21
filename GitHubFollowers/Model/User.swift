//
//  User.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/8/20.
//

import Foundation

struct User: Codable{
    
    let login: String
    let avatar_url: String
    var name: String?
    var location: String?
    var bio: String?
    let public_repos: Int
    let public_gists: Int
    let html_url: String
    let following: Int
    let followers: Int
    let created_at: String
}

