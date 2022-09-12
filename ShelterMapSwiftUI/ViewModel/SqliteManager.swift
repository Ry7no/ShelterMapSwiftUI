//
//  SqliteManager.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/9.
//

import Foundation
import SwiftUI
import SQLite
import CoreLocation
import WidgetKit

class SqliteManager: ObservableObject {
    
    private var db: Connection!
    private var all: Table!
    private var category: Expression<String>!
    private var code: Expression<String>!
    private var village: Expression<String>!
    private var address: Expression<String>!
    private var latitude: Expression<Double>!
    private var longitude: Expression<Double>!
    private var underFloor: Expression<String>!
    private var capacity: Expression<String>!
    private var office: Expression<String>!
    private var distance: Expression<Double>!
    
    @Published var shelters: [Shelter] = []
    @Published var radius: CGFloat = 200
    
    var count = 0
    
    init() {
        
        DispatchQueue.main.async {
            LocationManager().requestUserLocation()
        }
        
        do {
            
            let allDataPath = Bundle.main.path(forResource: "all", ofType: "sqlite")
            print("\(String(describing: allDataPath))")
            db = try Connection(allDataPath!, readonly: true)
            
            all = Table("all")
            category = Expression<String>("category")
            code = Expression<String>("code")
            village = Expression<String>("village")
            address = Expression<String>("address")
            latitude = Expression<Double>("latitude")
            longitude = Expression<Double>("longitude")
            underFloor = Expression<String>("underFloor")
            capacity = Expression<String>("capacity")
            office = Expression<String>("office")
            
        } catch {
            print("error: \(error.localizedDescription)")
        }
        
//        self.getSheltersAll(range: radius)
        
//        if shelters.isEmpty {
//            radius = radius + 200
//            self.getSheltersAll(range: radius)
//            print("@radius: \(radius)")
//        }
    }
    
    
    func getSheltersAll(range: Double) {
        
        do {
            for shelter in try db.prepare(all) {
                
                let category = shelter[category]
                let code = shelter[code]
                let village = shelter[village]
                let address = shelter[address]
                let latitude = shelter[latitude]
                let longitude = shelter[longitude]
                let underFloor = shelter[underFloor]
                let capacity = shelter[capacity]
                let office = shelter[office]
                
                let userPosition = CLLocation(latitude: UserDefaults.standard.double(forKey: "userCurrentPositionLAT"),
                                              longitude: UserDefaults.standard.double(forKey: "userCurrentPastPositionLON"))
                let shelterPosition = CLLocation(latitude: latitude, longitude: longitude)
                let distance = userPosition.distance(from: shelterPosition).rounded()

                count = count + 1
                print(count)
                if distance < range {
                    
                    let shelterInDb = Shelter(category: category, code: code, village: village, address: address, latitude: latitude, longitude: longitude, underFloor: String(underFloor), capacity: String(capacity), office: office, distance: distance)

                    self.shelters.append(shelterInDb)
                }
  
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        self.shelters = self.shelters.sorted(by: { $0.distance < $1.distance })
        
        if shelters.count > 0 {
            
            let nearestCategory = shelters[0].category
            let nearestAddress = shelters[0].address
            let nearestUnderFloor = shelters[0].underFloor
            let nearestCapacity = shelters[0].capacity
            let nearestDistance = Int(shelters[0].distance)
            let totalCount = shelters.count
            
            UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.set(nearestCategory, forKey: "nearestCategory")
            UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.set(nearestAddress, forKey: "nearestAddress")
            UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.set(nearestUnderFloor, forKey: "nearestUnderFloor")
            UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.set(nearestCapacity, forKey: "nearestCapacity")
            UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.set(nearestDistance, forKey: "nearestDistance")
            UserDefaults(suiteName: "group.com.novachen.ShelterMapSwiftUI")!.set(totalCount, forKey: "totalCount")
            
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    
//    func getSheltersTaipei(range: Double) -> [Shelter] {
//
//        var shelterTaipei: [Shelter] = []
////        taipei = taipei.order(fid.asc)
//
//        do {
//            for shelter in try db.prepare(taipei) {
//
//                let fid = shelter[fid]
//                let category = shelter[category]
//                let code = shelter[code]
//                let village = shelter[village]
//                let address = shelter[address]
//                let coordinateString = shelter[coordinateString]
//                let underFloor = shelter[underFloor]
//                let capacity = shelter[capacity]
//                let office = shelter[office]
//                let remarks = shelter[remarks]
//
//                let coordinates = coordinateString.components(separatedBy: ",")
//
//                let latitude = Double(coordinates[0]) ?? 0.0
//                let longitude = Double(coordinates[1]) ?? 0.0
//
//                let userPosition = CLLocation(latitude: UserDefaults.standard.double(forKey: "userCurrentPositionLAT"),
//                                              longitude: UserDefaults.standard.double(forKey: "userCurrentPastPositionLON"))
//                let shelterPosition = CLLocation(latitude: latitude, longitude: longitude)
//                let distance = userPosition.distance(from: shelterPosition).rounded()
//
//                if distance < range {
//                    let shelterInDb = Shelter(fid: fid, category: category, code: code, village: village, address: address, latitude: latitude, longitude: longitude, underFloor: underFloor, capacity: capacity, office: office, remarks: remarks, distance: distance)
//
//                    shelterTaipei.append(shelterInDb)
//                }
//
//            }
//
//        } catch {
//            print(error.localizedDescription)
//        }
//        shelterTaipei = shelterTaipei.sorted(by: { $0.distance < $1.distance })
////        shelterTaipei = shelterTaipei.sorted(by: { $0.distance < $1.distance })
//        print("@get Shelter Taipei")
//        return shelterTaipei
//    }
    
//    
//    func filterShelters(filterDistance: Double) -> [Shelter] {
//        
//        var shelterModels: [Shelter] = []
//        shelters = shelters.order(distance.asc)
//        
//        do {
//            for shelter in try db.prepare(shelters.filter(distance < filterDistance)) {
//                
//                let category = shelter[category]
//                let code = shelter[code]
//                let village = shelter[village]
//                let address = shelter[address]
//                let latitude = shelter[latitude]
//                let longitude = shelter[longitude]
//                let underFloor = shelter[underFloor]
//                let capacity = shelter[capacity]
//                let office = shelter[office]
//                let remarks = shelter[remarks]
//                let distance = shelter[distance]
//
//                let shelterInDb = Shelter(category: category, code: code, village: village, address: address, latitude: latitude, longitude: longitude, underFloor: underFloor, capacity: capacity, office: office, remarks: remarks, distance: distance)
//                
//                shelterModels.append(shelterInDb)
//            }
//            
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//        return shelterModels
//    }
}
