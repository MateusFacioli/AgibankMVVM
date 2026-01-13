//
//  LocationModel.swift
//  testeMVVM
//
//  Created by Maurício Fonseca on 13/01/26.
//

// Equatable para realizar validações de equidade

import MapKit
import CoreLocation

struct LocationModel: Equatable, Codable{
    
    let latitude: Double
    let longitude: Double
    
    
}


extension LocationModel{
    
    var clCoordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
