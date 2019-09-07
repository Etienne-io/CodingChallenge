//
//  PhotoCollectionViewCell.swift
//  UBCodingChallenge
//
//  Created by Etienne Mercier on 07/09/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

import UIKit

/**
 PhotoCollectionViewCell is responsible to display the image inside collection view.
 It displays a placeholder until a image is available
 */
class PhotoCollectionViewCell: UICollectionViewCell {
    var flickrPhoto: FlickrPhoto?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = UIImage(named: "placeholder")
    }

    func configure(flickrPhoto: FlickrPhoto?) {
        guard let flickrPhoto = flickrPhoto else {
            imageView.image = UIImage(named: "placeholder")
            return
        }
        guard let url = URL(string: flickrPhoto.getImageUrlString()) else {
            imageView.image = UIImage(named: "placeholder")
            return;
        }
        imageView.image = UIImage(named: "placeholder")
        imageView.load(url: url)
    }
}
