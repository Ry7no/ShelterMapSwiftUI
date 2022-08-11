//
//  Shelter.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/4.
//

import SwiftUI
import MapKit

struct Shelter: Identifiable, Equatable {
    
    var category: String
    var code: String
    var village: String
    var address: String
    var latitude: Double
    var longitude: Double
    var underFloor: String
    var capacity: String
    var office: String
    var distance: Double = 0.0
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var id = UUID()

    static func == (lhs: Shelter, rhs: Shelter) -> Bool {
        lhs.id == rhs.id
    }

}
