//
//  MapPin.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/20/23.
//

import MapKit

protocol Pinable {
    var latitude: Double { get set }
    var longitude: Double { get set }
    var imageURL: String { get set }
    
}

class MapPin: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    let pinable: Pinable
    
    init(pinable: Pinable) {
        self.pinable = pinable
        self.coordinate = CLLocationCoordinate2D(latitude: pinable.latitude, longitude: pinable.longitude)
    }
}
