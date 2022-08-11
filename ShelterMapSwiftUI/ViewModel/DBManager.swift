//
//  DBManager.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/7.
//

import Foundation
import SQLite

class DBManager {
    
    private var db: Connection!
    private var shelters: Table!
//    private var taipei: Table!
//    private var nearShelters: Table!
    
//    private var fid: Expression<Int>
    private var id: Expression<UUID>!
    private var category: Expression<String>!
    private var code: Expression<String>!
    private var village: Expression<String>!
    private var address: Expression<String>!
    private var latitude: Expression<Double>!
    private var longitude: Expression<Double>!
    private var underFloor: Expression<String>!
    private var capacity: Expression<String>!
    private var office: Expression<String>!
    private var remarks: Expression<String>!
    private var distance: Expression<Double>!
    
    init() {
        do {
            
            // Taipei
//            let taipeiSqlitePath = Bundle.main.path(forResource: "Taipei", ofType: "sqlite")
//            db = try Connection(taipeiSqlitePath!, readonly: true)
            
            // Taichung
//            let fileManager = FileManager.default
//            do {
//                let fileURL = NSURL(fileURLWithPath: "\(path)/shelterData.sqlite3")
//                try fileManager.removeItem(at: fileURL as URL)
//            } catch {
//                print(error.localizedDescription)
//            }
            
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            
            // Creating database connection
            db = try Connection("\(path)/shelterData.sqlite3")
 
            // Creating table object
//            taipei = Table("Taipei")
            shelters = Table("shelters")
//            nearShelters = Table("nearShelters")
            
            // Creating instance of each column
//            fid = Expression<Int>("OGC_FID")
            id = Expression<UUID>("id")
            category = Expression<String>("category")
            code = Expression<String>("code")
            village = Expression<String>("village")
            address = Expression<String>("address")
            latitude = Expression<Double>("latitude")
            longitude = Expression<Double>("longitude")
            underFloor = Expression<String>("underFloor")
            capacity = Expression<String>("capacity")
            office = Expression<String>("office")
            remarks = Expression<String>("remarks")
            distance = Expression<Double>("distance")
            
//            if (!UserDefaults.standard.bool(forKey: "dbIsCreated")) {
//                try db.run(shelters.create { item in
//                    item.column(id, primaryKey: true)
//                    item.column(category)
//                    item.column(code)
//                    item.column(village)
//                    item.column(address)
//                    item.column(latitude)
//                    item.column(longitude)
//                    item.column(underFloor)
//                    item.column(capacity)
//                    item.column(office)
//                    item.column(remarks)
//                    item.column(distance)
//                })
//
//                UserDefaults.standard.set(true, forKey: "dbIsCreated")
//            }
            
//            if (!UserDefaults.standard.bool(forKey: "nearDbIsCreated")) {
//                try db.run(nearShelters.create { item in
//                    item.column(id, primaryKey: true)
//                    item.column(category)
//                    item.column(code)
//                    item.column(village)
//                    item.column(address)
//                    item.column(latitude)
//                    item.column(longitude)
//                    item.column(underFloor)
//                    item.column(capacity)
//                    item.column(office)
//                    item.column(remarks)
//                    item.column(distance)
//                })
//
//                UserDefaults.standard.set(true, forKey: "nearDbIsCreated")
//            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addShelter(shelter: Shelter) {
        do {
            
            try db.run(shelters.insert(
                                       category <- shelter.category,
                                       code <- shelter.code,
                                       village <- shelter.village,
                                       address <- shelter.address,
                                       latitude <- shelter.latitude,
                                       longitude <- shelter.longitude,
                                       underFloor <- shelter.underFloor,
                                       capacity <- shelter.capacity,
                                       office <- shelter.office,
//                                       remarks <- shelter.remarks,
                                       distance <- shelter.distance))
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    func addNearShelters(shelter: Shelter) {
//        do {
//
//            try db.run(nearShelters.insert(id <- shelter.id,
//                                           category <- shelter.category,
//                                           code <- shelter.code,
//                                           village <- shelter.village,
//                                           address <- shelter.address,
//                                           latitude <- shelter.latitude,
//                                           longitude <- shelter.longitude,
//                                           underFloor <- shelter.underFloor,
//                                           capacity <- shelter.capacity,
//                                           office <- shelter.office,
//                                           remarks <- shelter.remarks,
//                                           distance <- shelter.distance))
//
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
    func updateDistance(updateLatitude: Double, updateLlongitude: Double, updatedDistance: Double) {
        
        let uniq = shelters.filter(latitude == updateLatitude && longitude == updateLlongitude)
        
        do {
            if try db.run(uniq.update(distance <- updatedDistance)) > 0 {
                print("Updated distance")
            } else {
                print("Error occured during updating")
            }

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getShelters() -> [Shelter] {
        
        var shelterModels: [Shelter] = []
        shelters = shelters.order(distance.asc)
        
        do {
            for shelter in try db.prepare(shelters) {
                
                let category = shelter[category]
                let code = shelter[code]
                let village = shelter[village]
                let address = shelter[address]
                let latitude = shelter[latitude]
                let longitude = shelter[longitude]
                let underFloor = shelter[underFloor]
                let capacity = shelter[capacity]
                let office = shelter[office]
                let remarks = shelter[remarks]

                let shelterInDb = Shelter(category: category, code: code, village: village, address: address, latitude: latitude, longitude: longitude, underFloor: underFloor, capacity: capacity, office: office)
                
                shelterModels.append(shelterInDb)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return shelterModels
    }
    
    func filterShelters(filterDistance: Double) -> [Shelter] {
        
        var shelterModels: [Shelter] = []
        shelters = shelters.order(distance.asc)
        
        do {
            for shelter in try db.prepare(shelters.filter(distance < filterDistance)) {
                
                let category = shelter[category]
                let code = shelter[code]
                let village = shelter[village]
                let address = shelter[address]
                let latitude = shelter[latitude]
                let longitude = shelter[longitude]
                let underFloor = shelter[underFloor]
                let capacity = shelter[capacity]
                let office = shelter[office]
                let remarks = shelter[remarks]
                let distance = shelter[distance]

                let shelterInDb = Shelter(category: category, code: code, village: village, address: address, latitude: latitude, longitude: longitude, underFloor: underFloor, capacity: capacity, office: office, distance: distance)
                
                shelterModels.append(shelterInDb)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return shelterModels
    }
    
//    func getNearShelters() -> [Shelter] {
//
//        var shelterModels: [Shelter] = []
//        nearShelters = nearShelters.order(distance.asc)
//
//        do {
//            for shelter in try db.prepare(nearShelters) {
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
    
//    func recreateNearShelters() {
//        
////        var shelterModels: [Shelter] = []
////        nearShelters = nearShelters.order(distance.asc)
//        print("reCreate")
//        
//        do {
//            
//            try db.run(nearShelters.delete())
//            
////            try db.run(nearShelters.drop(ifExists: true))
//            
//            try db.run(nearShelters.create { item in
//                item.column(id, primaryKey: true)
//                item.column(category)
//                item.column(code)
//                item.column(village)
//                item.column(address)
//                item.column(latitude)
//                item.column(longitude)
//                item.column(underFloor)
//                item.column(capacity)
//                item.column(office)
//                item.column(remarks)
//                item.column(distance)
//            })
//            
//            UserDefaults.standard.set(true, forKey: "nearDbIsCreated")
//            
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//    }

    
}
