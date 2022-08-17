//
//  ContentView.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/4.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @StateObject private var mapManager = MapManager()
    @StateObject private var sqliteManager = SqliteManager()
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    
    var body: some View {
        
        MapView()
            .environmentObject(sqliteManager)
            .environmentObject(mapManager)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut) {
                        launchScreenManager.dismiss()
                    }
                }
            }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
