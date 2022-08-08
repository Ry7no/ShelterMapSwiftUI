//
//  DataManager.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/4.
//

import Foundation
import SwiftUI
import UIKit
import CoreLocation
import MapKit
import SQLite

class DataManager: ObservableObject {
    
    @ObservedObject private var locationManager = LocationManager()
    
    let mySpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    @Published var Shelters: [Shelter] = []
    @Published var nearShelters: [Shelter] = []

    func convertCSVFile(name: String) {
        
        Shelters.removeAll()
        var count = 0
        
//        UserDefaults.standard.set(false, forKey: "dbIsCreated")
//        UserDefaults.standard.set(false, forKey: "nearDbIsCreated")
        
//        if (!UserDefaults.standard.bool(forKey: "dbIsCreated")) {
            
            
            //locate the file you want to use
            guard let filepath = Bundle.main.path(forResource: name, ofType: "csv") else {
                return
            }
            
            //convert that file into one long string
            var data = ""
            do {
                data = try String(contentsOfFile: filepath)
            } catch {
                print(error)
                return
            }
            
            //now split that string into an array of "rows" of data.  Each row is a string.
            var rows = data.components(separatedBy: "\n")
            
            //if you have a header row, remove it here
            rows.removeFirst()
            
            //now loop around each row, and split it into each of its columns
            for row in rows {
                
                let columns = row.components(separatedBy: ",")
                
                //check that we have enough columns
                if columns.count == 10 {

                    let category = columns[0]
                    let code = columns[1]
                    let village = columns[2]
                    let address = columns[3]
                    
                    var latitude = columns[4]
                    latitude = latitude.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)
                    
                    var longitude = columns[5]
                    longitude = longitude.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)
                    
                    let underFloor = columns[6]
                    let capacity = columns[7]
                    let office = columns[8]
                    let remarks = columns[9]

                    let shelterInColumn = Shelter(category: category, code: code, village: village, address: address, latitude: latitude, longitude: longitude, underFloor: underFloor, capacity: capacity, office: office, remarks: remarks)
                    
                    Shelters.append(shelterInColumn)
                    DBManager().addShelter(shelter: shelterInColumn)
                    
                    count = count + 1
                    print(count)

                }
            }
            
            
    
//        } else {
//            self.Shelters = DBManager().getShelters()
//            self.nearShelters = DBManager().getNearShelters()
//
//        }
        compareWithRadius(radius: 200)
    }
    
    func compareWithRadius(radius: Double) {
        
        nearShelters.removeAll()
        let userPosition = CLLocation(latitude: locationManager.userPosition.latitude, longitude: locationManager.userPosition.longitude)
        
        for index in 0..<Shelters.count - 1 {
            
            
            let shelterPosition = CLLocation(latitude: Double(Shelters[index].latitude) ?? 0.0,
                                             longitude: Double(Shelters[index].longitude) ?? 0.0)
            let distanceBetween = userPosition.distance(from: shelterPosition).rounded()
            Shelters[index].distance = distanceBetween

            if distanceBetween < radius {
                nearShelters.append(Shelters[index])
//                DBManager().addNearShelters(shelter: Shelters[index])
            }
            
        }
        print(nearShelters.isEmpty)
        nearShelters = nearShelters.sorted(by: { $0.distance < $1.distance })
//        mapManager.shelters = nearShelters
        print(nearShelters)
        
    }
}





/*
 CoreData Area
 
 static let shared = DataManager()
 
 private let container: NSPersistentContainer
 private let containerName: String = "CoreData"
 private let shelterEntityString: String = "ShelterEntity"
 
 @Published var savedShelterEntities: [ShelterEntity] = []
 
 init() {
     container = NSPersistentContainer(name: containerName)
     container.loadPersistentStores { (_, error) in
         if let error = error {
             print("Error loading Core Data! \(error.localizedDescription)")
         }
     }
     fetchShelters()
 }
 
 private func fetchShelters() {
     let request = NSFetchRequest<ShelterEntity>(entityName: shelterEntityString)
     do {
         savedShelterEntities = try container.viewContext.fetch(request)
     } catch let error {
         print("Error fetching Patient Entities. \(error.localizedDescription)")
     }
 }
 
 private func addShelter(shelter: Shelter) {
     let entity = ShelterEntity(context: container.viewContext)
     entity.id = shelter.id
     entity.category = shelter.category
     entity.code = shelter.code
     entity.village = shelter.village
     entity.address = shelter.address
     entity.latitude = shelter.latitude
     entity.longitude = shelter.longitude
     entity.underFloor = shelter.underFloor
     entity.capacity = shelter.capacity
     entity.office = shelter.office
     entity.remarks = shelter.remarks
     entity.distance = shelter.distance
     saveData()

 }
 
 private func saveData() {
     do {
         try container.viewContext.save()
         fetchShelters()
     } catch let error {
         print("Error saving to Core Data. \(error.localizedDescription)")
     }
 }
 
 private func applyChangesShelter() {
     saveData()
     fetchShelters()
 }
 
 */
