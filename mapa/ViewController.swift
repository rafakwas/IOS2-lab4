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

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var startButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var adressLabel: UILabel!
    @IBOutlet var map: MKMapView!
    let regionRadius : CLLocationDistance = 1000
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        adressLabel.text = ""
        stopButton.isEnabled = false
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let currentLocation : CLLocation = CLLocation(latitude : location.coordinate.latitude, longitude : location.coordinate.longitude)
        
        addAnnotation(location: currentLocation)
        centerMapWithZoomAdjust(location: currentLocation, speed: location.speed)
        setAdressLabel(location: currentLocation)
        
        self.map.showsUserLocation = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func startOnClick(_ sender: Any) {
        startButton.isEnabled = false
        stopButton.isEnabled = true
        print("rozpoczynanie śledzenia")
        manager.startUpdatingLocation()
        
    }
    
    @IBAction func stopOnClick(_ sender: Any) {
        stopButton.isEnabled = false
        startButton.isEnabled = true
        print("zatrzymywanie śledzenia")
        manager.stopUpdatingLocation()
    }
    
    @IBAction func clearOnClick(_ sender: Any) {
        print("czyszczenie znaczników")
        map.removeAnnotations(map.annotations)
    }
    
    func centerMapWithZoomAdjust(location: CLLocation, speed: CLLocationSpeed) {
        print("current speed: \(speed)")
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func addAnnotation(location: CLLocation) {
        let currentLocation = CLLocationCoordinate2D(latitude : location.coordinate.latitude,longitude : location.coordinate.longitude)
        let annotation = Annotation(coordinate : currentLocation)
        map.addAnnotation(annotation)
    }
    
    func setAdressLabel(location : CLLocation) {
        geoCoder.reverseGeocodeLocation(location) {(placemarks,error) -> Void in
            let array = placemarks as [CLPlacemark]!
            var placemark : CLPlacemark!
            placemark = array?[0]
            var textStringBuilder = ""
            let delimiter = " "
            if let postalCode = placemark.postalCode {
                textStringBuilder.append(postalCode)
                textStringBuilder.append(delimiter)
            }
            if let city = placemark.locality {
                textStringBuilder.append(city)
                textStringBuilder.append(delimiter)
            }
            if let street = placemark.thoroughfare {
                textStringBuilder.append(street)
                textStringBuilder.append(delimiter)
            }
            if let number = placemark.subThoroughfare {
                textStringBuilder.append(number)
                textStringBuilder.append(delimiter)
            }
            self.adressLabel.text = textStringBuilder
        }
    }
}

