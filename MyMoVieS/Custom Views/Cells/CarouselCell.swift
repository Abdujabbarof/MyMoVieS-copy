//
//  CarouselCell.swift
//  MyMoVieS
//
//  Created by Abdulloh on 31/07/24.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CarouselCell"
    let cache = NetworkManager.shared.cache
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func configure(with film: Film) {
        if let urlString = film.posterUrl, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            imageView.image = nil // or a placeholder image
        }
    }
    
    private func loadImage(from url: URL) {
        let urlString = url.absoluteString
        
        // Check if the image is already in cache
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            imageView.image = cachedImage
            return
        }
        
        // Optionally set a placeholder image while loading
        imageView.image = UIImage(named: "placeholder-image")
        
        // Fetch the image data
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, error == nil, let data = data, let image = UIImage(data: data) else {
                // Handle the error or set a default image
                return
            }
            
            // Cache the image
            self.cache.setObject(image, forKey: urlString as NSString)
            
            // Set the image on the main thread
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        task.resume()
    }
}
