//
//  PersistenceManager.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 11/10/20.
//

import Foundation

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    // saving string as constant
    enum Keys {
        static let favorites = "favorites"
    }
    
    // going to return result type. In success case going to return an array of favorited followers or an error
    // first use case if nothing is there it will return nill (an empty array) first time using it
    static func retrieveFavorites(completed: @escaping (Result<[Follower],GFError>) -> Void){
        // since defaults.object is Any type we have to cast it as Data
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        // if favoritesData is good we handle the data
        do {
            // init decoder
            let decoder = JSONDecoder()
            // create an array of favorites with a try/catch block
            // decode data into a type of array of favorites
            // if goes well pass array of favorites to completion handler
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
}

