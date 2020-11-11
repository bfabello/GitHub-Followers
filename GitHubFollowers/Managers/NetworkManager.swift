//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/8/20.
//

import UIKit

class NetworkManager {
    
    // static = every network manager will have this on it
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    // cache for storing avatar images
    let cache = NSCache<NSString, UIImage>()
    
    private init(){}
     
    /// Get followers from github API
    /// - Parameters:
    ///     - username: which username to get followers
    ///     - page: for pagination of scrolling
    ///     - completed: completion handler (closrue) that return either an array of followers or an error message - one or the other
    func getFollowers(for username: String, page: Int, completed: @escaping(Result<[Follower], GFError>) -> Void){
        // get url
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        // if we get dont get a valid url
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        // if we get a valid url from the API it will return data, response, and error
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // if error exists from request
            if let _ = error{
                completed(.failure(.unableToComplete))
            }
            
            // if response is valid from request and is status 200 OK
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            // if data is not nil
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            // if all is good we handle the data
            do {
                let decoder = JSONDecoder()
                 // use this line if you are using camel case for API variable names instead of default snake case
                // decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // create an array of followers with a try/catch block
                // decode data into a type of array of followers
                // if goes well pass array of follwers to completion handler
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        // make sure to call to fire off API
        task.resume()
    }
    
    /// Get user info from github API
    /// - Parameters:
    ///     - username: which username to get followers
    ///     - completed: completion handler (closrue) that return either a user  or an error message - one or the other
    func getUserInfo(for username: String, completed: @escaping(Result<User, GFError>) -> Void){
        // get url
        let endpoint = baseURL + "\(username)"
        
        // if we get dont get a valid url
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        // if we get a valid url from the API it will return data, response, and error
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // if error exists from request
            if let _ = error{
                completed(.failure(.unableToComplete))
            }
            
            // if response is valid from request and is status 200 OK
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            // if data is not nil
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            // if all is good we handle the data
            do {
                let decoder = JSONDecoder()
                // use this line if you are using camel case for API variable names instead of default snake case
                // decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // create a user with a try/catch block
                // decode data into a type of User
                // if goes well pass user to completion handler
                let user = try decoder.decode(User.self, from: data)
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        // make sure to call to fire off API
        task.resume()
    }
}
