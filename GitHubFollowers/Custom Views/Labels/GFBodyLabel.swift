//
//  GFBodyLabel.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/6/20.
//

import UIKit

class GFBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // used convenience init so we dont have to call configure in all our custom initializers
    convenience init(textAlignment: NSTextAlignment){
        self.init(frame: .zero)
        self.textAlignment = textAlignment
    }
    
    private func configure(){
        textColor = .secondaryLabel
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }

}
