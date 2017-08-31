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
        print("pins count \(pins?.count)")
        if pins != nil {
            for pin in pins!{
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                map.addAnnotation(annotation)
            }
        }
    }

    @IBAction func addPin(){
        print("addPin called")
        let touchPoint = gestureRecognizer.location(in: map)
        let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        map.addAnnotation(annotation)
        Pin(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude, context: delegate.stack.context)
        save()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        performSegue(withIdentifier: "LocationToPhotos", sender: view.annotation?.coordinate)
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "LocationToPhotos" {
            let destination = segue.destination as! PhotosViewController
            destination.coordinates = sender as! CLLocationCoordinate2D
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
    
    func save(){
        print("save called")
        do {
            //print("Total number of points saved \(try delegate.stack.context.fetch(Pin.fetchRequest()).count)")
            try delegate.stack.context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }

    }
}

