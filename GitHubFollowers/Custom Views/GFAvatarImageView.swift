//
//  GFAvatarImageView.swift
//  GitHubFollowers
//
//  Created by Brian Fabello on 10/9/20.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let placeholderImage = UIImage(named: "avatar-placeholder")!
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String){
        // if image is in the cache, look it up and set it
        // else run network call below
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        // check if URL is valid
        guard let url = URL(string: urlString) else { return }
        
        // make network call
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            // anytime error happens just bounce out and return instead of displaying errors
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            // if we have good data, set the image
            guard let image = UIImage(data: data) else { return }
            
            // set image to cache after making network call
            self.cache.setObject(image, forKey: cacheKey)
            
            // update anything UI on the main thread
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
