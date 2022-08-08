//
//  MapManager.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/5.
//

import Foundation
import MapKit
import SwiftUI


class MapManager: ObservableObject {

    @ObservedObject private var locationManager = LocationManager()
    private var dataManager = DataManager()
    
    @Published var shelters: [Shelter] = []

    @Published var mapShelter: Shelter {
        didSet {
            updateMapRegion(shelter: mapShelter)
        }
    }
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let shelterSpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    
    @Published var showShelterList: Bool = false
    
    @Published var sheetShelter: Shelter? = nil
    
    init() {
  
        var shelters = dataManager.nearShelters
//        var shelters = DBManager().getNearShelters()
        if shelters.isEmpty {
            shelters.append(Shelter.init(category: "", code: "", village: "", address: "", latitude: "", longitude: "", underFloor: "", capacity: "0", office: "", remarks: "", distance: 0.0))
        }
        self.shelters = shelters
        
        self.mapShelter = shelters.first!
        
        DispatchQueue.main.async {
            withAnimation {
                self.mapRegion.center = self.locationManager.userPosition
                self.mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            }
        }
    }

    private func updateMapRegion(shelter: Shelter) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: shelter.coordinates,
                span: shelterSpan)
        }
    }
    
    func toggleSheltersList() {
        withAnimation(.easeInOut) {
            showShelterList.toggle()
        }
    }
    
    func showNextShelter(shelter: Shelter) {
        withAnimation(.easeInOut) {
            mapShelter = shelter
            showShelterList = false
        }
    }
    
    func nextButtonPressed() {
        
        guard let currentIndex = shelters.firstIndex(where: { $0 == mapShelter }) else { return }
        
        let nextIndex = currentIndex + 1
        guard shelters.indices.contains(nextIndex) else {
            guard let firstShelter = shelters.first else { return }
            showNextShelter(shelter: firstShelter)
            return
        }
        
        let nextShelter = shelters[nextIndex]
        showNextShelter(shelter: nextShelter)
    }
    
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String) {
      let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
      let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = name // Provide the name of the destination in the To: field
      mapItem.openInMaps(launchOptions: options)
    }
    
}
