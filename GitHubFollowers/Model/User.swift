//
//  User.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/8/20.
//

import Foundation

struct User: Codable{
    
    var login: String
    var avatar_url: String
    var name: String?
    var location: String?
    var bio: String?
    var public_repos: Int
    var public_gists: Int
    var html_url: String
    var following: Int
    var followers: Int
    var create_at: String
    
}

