//
//  MapView.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/4.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var mapManager: MapManager

    @State var tracking: MapUserTrackingMode = .none
    
    private let timer = Timer.publish(every: 0.6, on: .main, in: .common).autoconnect()
    @State private var isBreathing: Bool = false
    @State private var isShakeAnimating: Bool = false
    
    @State var shelters: [Shelter] = []
    
    var body: some View {

        ZStack {
            
            mapLayer
                .ignoresSafeArea()
            
            if dataManager.nearShelters.isEmpty {
                ProgressView()
                    .tint(.red)
                    .scaleEffect(x: 2, y: 2, anchor: .center)
            } else {
                VStack {
                    header
                        .padding()
                    
                    Spacer()
                    
                    shelterPreviewStack
                }
            }

        }
        .onAppear {
            DispatchQueue.main.async {
                dataManager.convertCSVFile(name: "Taichung")
            }
        }
        
    }
}

extension MapView {
    
    private var header: some View {
        
        VStack {
            Button {
                mapManager.toggleSheltersList()
            } label: {
                Text("\(Int(mapManager.mapShelter.distance))米, \(mapManager.mapShelter.category), 地下\(mapManager.mapShelter.underFloor)樓")
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: mapManager.mapShelter)
                    .overlay(alignment: .leading) {
                        Image(systemName: "chevron.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: mapManager.showShelterList ? 180 : 0))
                    }
            }

            if mapManager.showShelterList {
                SheltersListView()
            }
        }
        .background(.thinMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 5, y: 5)
        
    }
    
    private var mapLayer: some View {
        
        ZStack {
            
            Map(coordinateRegion: $mapManager.mapRegion,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $tracking,
                annotationItems: mapManager.shelters,
                annotationContent: { shelter in
                MapAnnotation(coordinate: shelter.coordinates) {
                    MapAnnotationView(name: shelter.category, capacity: shelter.capacity)
                        .scaleEffect(mapManager.mapShelter == shelter ? 1.4 : 0.8).animation(Animation.easeInOut)
//                        .rotationEffect(Angle(degrees:  mapManager.mapShelter == shelter ? (isShakeAnimating ? 5 : -5) : 0)).animation(Animation.spring())
                        .scaleEffect(CGSize(width: mapManager.mapShelter == shelter ? (isBreathing ? 1.08 : 1) : 1, height: mapManager.mapShelter == shelter ? (isBreathing ? 0.95 : 1) : 1), anchor: .center).animation(Animation.easeInOut(duration: 0.8))
                        .onReceive(timer) { input in
                            isBreathing.toggle()
                            isShakeAnimating.toggle()
                        }
                        .opacity(shelter.capacity == "0" ? 0 : 1)
                        .offset(y: -8)
                        .overlay(Circle()
                            .fill(Color.red.opacity(0.4))
                            .frame(width: 10, height: 10))
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapManager.showNextShelter(shelter: shelter)
                            }
                        }
                }
                
            })
            .onAppear {
                
                DispatchQueue.main.async {
                    mapManager.shelters.removeAll()
//                    mapManager.shelters = DBManager().getNearShelters()
                    dataManager.nearShelters.forEach { Shelter in
                        mapManager.shelters.append(Shelter)
                    }
                }
                
            }

        }
    }
    
    private var shelterPreviewStack: some View {
        ZStack {
            ForEach(mapManager.shelters) { shelter in
                
                if mapManager.mapShelter == shelter {
                    ShelterPreview(shelter: shelter)
                        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 5, y: 5)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
