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
            getPhotos()
        } else {
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (pin.photo?.count)!}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationPhotoCell", for: indexPath) as! PhotoCell
        let photo = pin.photo?.allObjects[indexPath.row] as! Photo
        cell.loadPhoto(photoObject: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //last item
        let photo = pin.photo?.allObjects[indexPath.row] as! Photo
        delegate.stack.context.delete(photo)
        collectionView.reloadData()
        delegate.stack.save()
    }
    
    @IBAction func loadPhotos(_ sender: Any) {
        for photo in pin.photo! {
            delegate.stack.context.delete(photo as! Photo)
        }
        pin.photo = NSSet()
        getPhotos()
    }
    
    var pages = 1
    func getPhotos(){
        FlickrNetworking.sharedInstance.retrievePhotoData(pin: pin, page: pages) {
            (sucess, error) in
            if sucess {
                print("networking request successful")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.delegate.stack.save()
                }
            }
        }
        pages = pages + 1
    }
}
