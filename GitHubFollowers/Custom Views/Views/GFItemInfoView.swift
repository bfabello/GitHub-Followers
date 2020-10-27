//
//  GFItemInfoView.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/26/20.
//
// Configure reusable UIView with SF symbol, title, and count 

import UIKit

// item info types inside container cards
enum ItemInfoType {
    case repos, gists, followers, following
}

class GFItemInfoView: UIView {

    let symbolImageView = UIImageView()
    let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubview(symbolImageView)
        addSubview(titleLabel)
        addSubview(countLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        // to make sure SF symbols aligned in imageView
        symbolImageView.contentMode = .scaleAspectFit
        // .label to match GFTitleLabel tint color
        symbolImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            // anchor of our layout - base everything around this SF Symbol
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
    }
    
    // formatting item info view
    // pass in an item info type and corresponding case will set correct items
    func set(itemInfoType: ItemInfoType, withCount count: Int){
        switch itemInfoType {
            case .repos:
                symbolImageView.image = UIImage(systemName: SFSymbols.repos)
                titleLabel.text = "Public Repos"
                countLabel.text = String(count)
            case .gists:
                symbolImageView.image = UIImage(systemName: SFSymbols.gists)
                titleLabel.text = "Public Gists"
                countLabel.text = String(count)
            case .followers:
                symbolImageView.image = UIImage(systemName: SFSymbols.followers)
                titleLabel.text = "Followers"
            case .following:
                symbolImageView.image = UIImage(systemName: SFSymbols.following)
                titleLabel.text = "Following"
        }
        countLabel.text = String(count)

    }
    
}
