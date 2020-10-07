//
//  UIViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/7/20.
//

import UIKit

extension UIViewController {
    
    // any view controller can call this function on main thread
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
