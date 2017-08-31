//
//  ViewController.swift
//  VirtualTourist
//
//  Created by joel johnson on 8/29/17.
//  Copyright © 2017 joel johnson. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var gestureBegin: Bool = false
    var gestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.addPin))
        map.addGestureRecognizer(gestureRecognizer)
        
    }

    @IBAction func addPin(){
        print("addPin called")
        let touchPoint = gestureRecognizer.location(in: map)
        let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        map.addAnnotation(annotation)
    }

}

