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
    var pin: Pin!
    let delegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinates = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        map.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 5,longitudeDelta: 5))
        map.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pin.photo?.count == 0 {
            print("pin photo set is nil")
            FlickrNetworking.sharedInstance.retrievePhotoData(pin: pin) {
                (sucess, error) in
                if sucess {
                    print("networking request successful")
                    print(self.pin.photo?.count)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.delegate.stack.save()
                    }
                }
            }
        }
        print("pin photo set isn't nil")
        print(pin.photo!)
        print(pin.photo!.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return (pin.photo?.count)!}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationPhotoCell", for: indexPath) as! PhotoCell
        let photo = pin.photo?.allObjects[indexPath.row] as! Photo
        let uiiamge = UIImage(data: photo.image! as Data)
        cell.photo = UIImageView(image: uiiamge)
        return cell
    }
}
