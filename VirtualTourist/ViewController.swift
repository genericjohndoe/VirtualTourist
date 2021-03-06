//
//  ViewController.swift
//  VirtualTourist
//
//  Created by joel johnson on 8/29/17.
//  Copyright © 2017 joel johnson. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class ViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var pins: [Pin]? = [Pin]()
    var selectedPin: Pin?
    var gestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.addPin))
        map.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pins = loadPins()

        if pins != nil {
            for pin in pins!{
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                map.addAnnotation(annotation)
            }
        }
    }

    @IBAction func addPin(){
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            print("addPin called")
            let touchPoint = gestureRecognizer.location(in: map)
            let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
            let newPin = Pin(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude, context: delegate.stack.context)
            pins?.append(newPin)
            delegate.stack.save() 
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            map.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        //print("pin selected")
        for pin in pins!{
            if pin.longitude == view.annotation?.coordinate.longitude && pin.latitude == view.annotation?.coordinate.latitude {
                selectedPin = pin
                print("pin set")
            }
        }
        performSegue(withIdentifier: "LocationToPhotos", sender: view.annotation?.coordinate)
        print("performSegue called")
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "LocationToPhotos" {
            print("prepare called")
            let destination = segue.destination as! PhotosViewController
            //destination.coordinates = sender as! CLLocationCoordinate2D
            destination.pin = selectedPin!
        }
    }
    
    func loadPins() -> [Pin]?{
        print("load pins")
        do {
            let marks: [Pin]? = try delegate.stack.context.fetch(Pin.fetchRequest())
            //print("total number of pins : \(marks.count)")
            return marks
        }catch {
            fatalError("errpr with fetch")
        }
    }
}

