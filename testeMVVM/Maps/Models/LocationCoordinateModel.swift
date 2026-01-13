//
//  LocationCoordinateModel.swift
//  testeMVVM
//
//  Created by Mateus Rodrigues on 12/01/26.
//

import MapKit
import CoreLocation

// permissoes -> info.plist NSLocationWhenInUseUsageDescription

struct LocationCoordinateModel: Equatable, Codable {
    let latitude: Double
    let longitude: Double
}

//mapkit
extension LocationCoordinateModel {
    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
