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
    
    @Published var shelters: [Shelter] = []

    @Published var mapShelter: Shelter {
        didSet {
            updateMapRegion(shelter: mapShelter)
        }
    }
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let shelterSpan = MKCoordinateSpan(latitudeDelta: 0.0008, longitudeDelta: 0.0008)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @Published var showShelterList: Bool = false
    
    @Published var sheetShelter: Shelter? = nil
    @Published var isCenter = false
    
    init() {

        let shelters = SqliteManager().shelters
        
        print("@init shelters array")
        print("@shelters.count: \(shelters.count)")
        
        self.shelters = shelters

        self.mapShelter = shelters.first ?? Shelter(category: "請下拉選擇或點擊圖標", code: "", village: "", address: "", latitude: 0.0, longitude: 0.0, underFloor: "", capacity: "", office: "")

        DispatchQueue.main.async {
            withAnimation {
                self.mapRegion.center = self.locationManager.userPosition
                self.mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            }
        }
    }
    
    func checkCenter() {
        if mapRegion.center.latitude.round(to: 4) == self.locationManager.userPosition.latitude.round(to: 4) {
            self.isCenter = true
        } else {
            self.isCenter = false
        }
    }

    private func updateMapRegion(shelter: Shelter) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: shelter.coordinates,
                span: shelterSpan)
        }
//        print("\(mapShelter.category) ?? \(shelter.category)")
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
            print("\(mapShelter.category) : \(shelter.category)")
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
    
    func resetCamera() {
        withAnimation {
            self.mapRegion.center = self.locationManager.userPosition
            self.mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        }
    }
    
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String) {
      let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
      let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = name // Provide the name of the destination in the To: field
      mapItem.openInMaps(launchOptions: options)
    }
    
}
