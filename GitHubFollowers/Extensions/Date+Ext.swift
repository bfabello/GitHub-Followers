//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 11/4/20.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
