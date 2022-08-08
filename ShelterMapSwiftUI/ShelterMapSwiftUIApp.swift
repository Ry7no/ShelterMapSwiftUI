//
//  ShelterMapSwiftUIApp.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/4.
//

import SwiftUI

@main
struct ShelterMapSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(LocationManager())
                .environmentObject(DataManager())
                .environmentObject(MapManager())
        }
    }
}
