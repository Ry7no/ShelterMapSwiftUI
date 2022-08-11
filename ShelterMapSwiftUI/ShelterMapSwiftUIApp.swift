//
//  ShelterMapSwiftUIApp.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/4.
//

import SwiftUI

@main
struct ShelterMapSwiftUIApp: App {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var mapManager = MapManager()
    @StateObject private var sqliteManager = SqliteManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(mapManager)
                .environmentObject(sqliteManager)
                
                
        }
    }
}
