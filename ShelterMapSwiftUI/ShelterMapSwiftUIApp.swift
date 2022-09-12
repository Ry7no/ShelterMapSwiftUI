//
//  ShelterMapSwiftUIApp.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/4.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ShelterMapSwiftUIApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var locationManager = LocationManager()
    @StateObject var launchScreenManager = LaunchScreenManager()

    var body: some Scene {

        WindowGroup {
            
            ZStack{

                if locationManager.userPosition.latitude == 24.140793 {
                    
                    LaunchScreenView()
                    
                } else {
                    
                    ContentView()
                        .environmentObject(locationManager)
                        .onAppear {
                            LocationManager.shared.requestUserLocation()
                        }
                    
                }
                

                if launchScreenManager.state != .completed {
                    LaunchScreenView()
                }
                
            }
            .environmentObject(launchScreenManager)
        }
        
//        WindowGroup {
//
//            if locationManager.userPosition.latitude == 24.140793 {
//                
//                LaunchScreenView()
//                
//            } else {
//                
//                ContentView()
//                    .environmentObject(locationManager)
//                    .onAppear {
//                        LocationManager.shared.requestUserLocation()
//                    }
//            }
//        }
    }
}
