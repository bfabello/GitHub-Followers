//
//  Followers.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/8/20.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatar_url: String
}
