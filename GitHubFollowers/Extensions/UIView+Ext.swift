//
//  UIView+Ext.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 1/5/21.
//

import UIKit

extension UIView{
    
    func addSubviews(_ views:UIView...){
        for view in views{
            addSubview(view)
        }
    }
}
