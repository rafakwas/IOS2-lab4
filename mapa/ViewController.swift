//
//  ViewController.swift
//  mapa
//
//  Created by Rafał on 03/11/2017.
//  Copyright © 2017 Rafał. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    @IBOutlet var startButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var adressLabel: UILabel!
    @IBOutlet var map: MKMapView!
    let regionRadius : CLLocationDistance = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
        adressLabel.text = ""
        stopButton.isEnabled = false
        let initialLocation = CLLocation(latitude : 50.0780153, longitude : 19.9197903)
        centerMap(location: initialLocation)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func startOnClick(_ sender: Any) {
        startButton.isEnabled = false
        stopButton.isEnabled = true
        print("rozpoczynanie śledzenia")
        let currentLocation = CLLocationCoordinate2D(latitude : 50.0780153, longitude : 19.9197903)
        let annotation = Annotation(coordinate : currentLocation)
        map.addAnnotation(annotation)
    }
    
    @IBAction func stopOnClick(_ sender: Any) {
        stopButton.isEnabled = false
        startButton.isEnabled = true
        print("zatrzymywanie śledzenia")
    }
    
    @IBAction func clearOnClick(_ sender: Any) {
        print("czyszczenie znaczników")
    }
    
    func centerMap(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }

}

