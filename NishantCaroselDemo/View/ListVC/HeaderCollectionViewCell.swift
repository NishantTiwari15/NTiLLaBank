//
//  HeaderCollectionViewCell.swift
//  NishantCaroselDemo
//
//  Created by webwerks on 30/01/23.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet declaration
    @IBOutlet weak var headerImage: UIImageView!
    
    // MARK: - Configure cell class
    func configureCell(_ model: ListModel) {
        if let imageName = model.imageUrl {
            ImageDownloader.shared.downloadImage(with: imageName, completionHandler: { (image, cached) in
                self.headerImage.image = image
            }, placeholderImage:  UIImage(named: "placeholder"))
        }
    }
}
