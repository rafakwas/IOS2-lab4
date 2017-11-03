//
//  Annotation.swift
//  mapa
//
//  Created by Rafał on 03/11/2017.
//  Copyright © 2017 Rafał. All rights reserved.
//

import Foundation
import MapKit

class Annotation : NSObject,MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate : CLLocationCoordinate2D) {
        self.coordinate = coordinate;
        super.init()
    }
}
