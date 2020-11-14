//
//  PersistenceManager.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 11/10/20.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    // saving string as constant
    enum Keys {
        static let favorites = "favorites"
    }
    
    // pass in our follower, add or remove, complete with error if doesnt go well
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void){
        retrieveFavorites { result in
            switch result {
                case .success(let favorites):
                    // make copy of favorites to add/remove from array
                    var retrievedFavorites = favorites
                    switch actionType{
                        case .add:
                            // check if our array does not contain the user already
                            guard !retrievedFavorites.contains(favorite) else {
                                completed(.alreadyInFavorites)
                                return
                            }
                            // if favorite is not in array
                            retrievedFavorites.append(favorite)
                        case .remove:
                            // remove instances where the followers match
                            // $0 each item iterating through
                            retrievedFavorites.removeAll {$0.login == favorite.login}
                    }
                    //if save is successful return with a nil
                    // not successful return with a GFError
                    completed(save(favorites: retrievedFavorites))
                case .failure(let error):
                    completed(error)
            }
        }
    }
    // decoding from data
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
    
    // encoding to data
    // GFError is optional bc if success going to return nill as GFError
    static func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            // save to UserDefaults
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}

