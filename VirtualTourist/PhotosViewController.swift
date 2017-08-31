//
//  PhotosViewController.swift
//  VirtualTourist
//
//  Created by joel johnson on 8/31/17.
//  Copyright © 2017 joel johnson. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PhotosViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var coordinates:CLLocationCoordinate2D!

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        map.addAnnotation(annotation)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return 0}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
