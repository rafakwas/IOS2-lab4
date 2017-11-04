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
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var currentRegionRadius : CLLocationDistance = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        adressLabel.text = ""
        stopButton.isEnabled = false
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        self.map.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let currentLocation : CLLocation = CLLocation(latitude : location.coordinate.latitude, longitude : location.coordinate.longitude)
        if(isChangeZoomNecessary(speed : location.speed)) {
            changeZoom(location: currentLocation, speed: location.speed)
        }
        print("Current speed: \(location.speed)")
        addAnnotation(location: currentLocation)
        self.map.userTrackingMode = MKUserTrackingMode.follow
        setAdressLabel(location: currentLocation)
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
        self.map.userTrackingMode = MKUserTrackingMode.none
        manager.stopUpdatingLocation()
        
    }
    
    @IBAction func clearOnClick(_ sender: Any) {
        map.removeAnnotations(map.annotations)
    }
    
    func changeZoom(location: CLLocation, speed: CLLocationSpeed) {
        let regionRadius : CLLocationDistance = getRegionRadius(speed: speed)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func isChangeZoomNecessary(speed: CLLocationSpeed) -> Bool {
        let newRegionRadius : CLLocationDistance = getRegionRadius(speed: speed)
        var result : Bool = false
        if (currentRegionRadius.isEqual(to: newRegionRadius)) {
            result = false
        } else {
            print("Changing zoom is necessary! Speed: \(speed)")
            print("Current region radius: \(currentRegionRadius) replaced by: \(newRegionRadius)")
            currentRegionRadius = newRegionRadius
            result = true
        }
        return result
    }
    
    func getRegionRadius(speed: CLLocationSpeed) -> CLLocationDistance {
        var regionRadius : CLLocationDistance;
        if (speed.isLess(than: 7)) {
           regionRadius = 1000
        } else if (speed.isLess(than: 20)) {
           regionRadius = 2000
        } else {
           regionRadius = 10000
        }
        return regionRadius
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

