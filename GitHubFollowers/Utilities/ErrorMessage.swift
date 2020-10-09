//
//  ErrorMessage.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/9/20.
//

import Foundation

enum ErrorMessage: String  {
    
    case invalidUsername = "This username created an invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from server. Please try again"
    case invalidData = "the data received from the server was invalid. Please try again"
    
}
