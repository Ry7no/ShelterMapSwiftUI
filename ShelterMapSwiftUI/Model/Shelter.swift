//
//  Shelter.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/4.
//

import SwiftUI
import MapKit

struct Shelter: Identifiable, Equatable {
    
    let id = UUID()
    var category: String
    var code: String
    var village: String
    var address: String
    var latitude: String
    var longitude: String
    var underFloor: String
    var capacity: String
    var office: String
    var remarks: String
    var distance: Double = 0.0
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0)
    }
    

}
