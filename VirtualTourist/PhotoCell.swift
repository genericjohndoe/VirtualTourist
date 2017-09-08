//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by joel johnson on 9/4/17.
//  Copyright © 2017 joel johnson. All rights reserved.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    func loadPhoto(photoObject: Photo){
        if let data = photoObject.image {
            photo.image = UIImage(data: data as Data)
            indicator.stopAnimating()
        } else {
            indicator.startAnimating()
            photo.image = #imageLiteral(resourceName: "loading")
            FlickrNetworking.sharedInstance.getPhotos(url: photoObject.imageurl!){
                (success, error, data) in
                if success{
                    DispatchQueue.main.async{
                        self.photo.image = UIImage(data: data!)
                        self.indicator.stopAnimating()
                    }
                }
            }
        }
    }
    
}
