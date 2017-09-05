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
        collectionView.delegate = self
        collectionView.dataSource = self
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
            FlickrNetworking.sharedInstance.retrievePhotoData(pin: pin) {
                (sucess, error) in
                if sucess {
                    //print("networking request successful")
                    //print(self.pin.photo?.count)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.delegate.stack.save()
                    }
                }
            }
        } else {
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print((pin.photo?.count)!)
        return (pin.photo?.count)!}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellforrowat called")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationPhotoCell", for: indexPath) as! PhotoCell
        let photo = pin.photo?.allObjects[indexPath.row] as! Photo
        cell.photo.image = UIImage(data: photo.image! as Data)
        return cell
    }
    
    @IBAction func loadPhotos(_ sender: Any) {
        //empty nsset linked to pin
        //delete photos from database
        //http request to load new photos
        //create new photo objects
        //link to pin
    }
}
