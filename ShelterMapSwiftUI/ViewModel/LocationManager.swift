//
//  LocationManager.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/4.
//

import Foundation
import MapKit
import SwiftUI
import CoreLocation
import WidgetKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    @Published var manager: CLLocationManager = .init()
    @Published var userPosition: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 24.140793, longitude: 120.676250)
    @Published var pastUserPosition: CLLocationCoordinate2D = .init()
    @Published var currentLocation: CLLocation = .init()
    
    @Published var isFollow: Bool = false
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    @Published var speeds = [CLLocationSpeed]()
    @Published var speedDouble = 0.0
    @Published var speedInt = 0
    
    var avgSpeed: CLLocationSpeed {
        return speeds.reduce(0,+)/Double(speeds.count) //the reduce returns the sum of the array, then dividing it by the count gives its average
    }
    var topSpeed: CLLocationSpeed {
        return speeds.max() ?? 0 //return 0 if the array is empty
    }

    override init() {
        super.init()
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        
        getLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.stopMonitoringLocation()
        }
    }
    
    func requestUserLocation() {
        manager.requestWhenInUseAuthorization()
    }
        
    func getLocation() {
        
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.distanceFilter = kCLDistanceFilterNone
        manager.startUpdatingLocation()
        manager.startMonitoringVisits()
        manager.startMonitoringSignificantLocationChanges()
        
        print(userPosition)
//        manager.allowsBackgroundLocationUpdates = true
//        manager.pausesLocationUpdatesAutomatically = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle Error
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let _ = locations.last else { return }
        manager.stopMonitoringSignificantLocationChanges()

        let locationValue: CLLocationCoordinate2D = manager.location!.coordinate
        pastUserPosition = userPosition
        userPosition = locationValue
        
        let location = locations[0]
        speeds.append(contentsOf: locations.map{$0.speed}) //append all new speed updates to the array
        
        // m/s to km/h
        let kmt = location.speed * (18/5)
        speedDouble = Double(kmt)
        speedInt = Int(kmt)
        
        UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.set(speedInt, forKey: "speedInt")
        UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.set(userPosition.latitude, forKey: "userPositionLatitude")
        UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.set(userPosition.longitude, forKey: "userPositionLongitude")

        UserDefaults.standard.set(userPosition.latitude, forKey: "userCurrentPositionLAT")
        UserDefaults.standard.set(userPosition.longitude, forKey: "userCurrentPastPositionLON")
//        UserDefaults.standard.set(pastUserPosition.latitude, forKey: "userPastPositionLAT")
//        UserDefaults.standard.set(pastUserPosition.longitude, forKey: "userPastPositionLON")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways: manager.requestLocation()
        case .authorizedWhenInUse: manager.requestLocation()
        case .denied: handleLocationError()
        case .notDetermined: manager.requestWhenInUseAuthorization()
        default: ()
        }
    }
    
    func startMonitoringLocation() {
        manager.startMonitoringSignificantLocationChanges()
        manager.startMonitoringVisits()
        manager.startUpdatingLocation()
    }
    
    func stopMonitoringLocation() {
        manager.stopMonitoringSignificantLocationChanges()
        manager.stopMonitoringVisits()
        manager.stopUpdatingLocation()
    }
    
    func handleLocationError() {
        // Handle Error
    }
    
    func openGoogleMap(latDouble: CLLocationDegrees, longDouble: CLLocationDegrees) {
//        guard let lat = booking?.booking?.pickup_lat, let latDouble =  Double(lat) else {Toast.show(message: StringMessages.CurrentLocNotRight);return }
//        guard let long = booking?.booking?.pickup_long, let longDouble =  Double(long) else {Toast.show(message: StringMessages.CurrentLocNotRight);return }
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latDouble),\(longDouble)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latDouble),\(longDouble)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
        
    }
    
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
