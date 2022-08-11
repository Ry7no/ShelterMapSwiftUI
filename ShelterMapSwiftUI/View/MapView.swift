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
//    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var mapManager: MapManager
    @EnvironmentObject private var sqliteManager: SqliteManager

    @Environment(\.colorScheme) var scheme
    
    @State var tracking: MapUserTrackingMode = .none
    @State var isExtending: Bool = false
    
    private let timer = Timer.publish(every: 0.6, on: .main, in: .common).autoconnect()
    @State private var isBreathing: Bool = false
    @State private var isShakeAnimating: Bool = false
    @State private var isShowingAlert = false
    @State private var isUserCenter = false
    
    @State var shelters: [Shelter] = []
    @State var distance: Double = 0.0
    
    var body: some View {

        ZStack {
            
            mapLayer
                .ignoresSafeArea()
            
            if mapManager.shelters.isEmpty {
                ProgressView()
                    .tint(.red)
                    .scaleEffect(x: 2, y: 2, anchor: .center)
            } else {
                VStack(alignment: .center) {
                    header
                        .padding()
                    
                    Spacer()
                    
                    HStack {
                        
                        HStack(spacing: 25) {
                            
                            Button {
                                
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    self.isExtending.toggle()
                                }
                                
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 20).bold())
                                    .rotationEffect(Angle(degrees: isExtending ? 180 : 0))
                                    .scaledToFit()
                                    .foregroundColor(scheme == .dark ? .white : .black)
                                    .padding()
//                                    .background(scheme == .dark ? .white.opacity(0.1) : .black.opacity(0.1))
                                    .background(content: {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.ultraThinMaterial)
                                    })
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(scheme == .dark ? .white : .black)
                                    }

                            }
                            
                            HStack(spacing: 25) {
                                
                                Button {
                                    mapManager.resetCamera()
                                } label: {
                                    Image(systemName: mapManager.isCenter ? "location.fill" : "location")
                                        .font(.system(size: 14).bold())
                                        .scaledToFit()
                                        .foregroundColor(scheme == .dark ? .white : .black)
                                        .padding()
//                                        .background(scheme == .dark ? .white.opacity(0.1) : .black.opacity(0.1))
                                        .background(content: {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(.thinMaterial)
                                        })
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 2).foregroundColor(scheme == .dark ? .white : .black)
                                        }
                                }
                                
                                Button {
                                    withAnimation {
                                        self.isShowingAlert.toggle()
                                    }
                                    
                                } label: {
                                    Image(systemName: "barometer")
                                        .font(.system(size: 18).bold())
                                        .scaledToFit()
                                        .foregroundColor(scheme == .dark ? .white : .black)
                                        .padding()
//                                        .background(scheme == .dark ? .white.opacity(0.1) : .black.opacity(0.1))
                                        .background(content: {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(.thinMaterial)
                                        })
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 2).foregroundColor(scheme == .dark ? .white : .black)
                                        }
                                }
                            }
                            .opacity(isExtending ? 1 : 0)
                        }
                        
                        Spacer()
                        
                        Button {
                            mapManager.nextButtonPressed()
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 22).bold())
                                .scaledToFit()
                                .foregroundColor(scheme == .dark ? .white : .black)
                                .padding()
//                                .background(scheme == .dark ? .white.opacity(0.1) : .black.opacity(0.1))
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.ultraThinMaterial)
                                })
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(scheme == .dark ? .white : .black)
                                }
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                    
                    shelterPreviewStack
                        .padding(.horizontal, 10)
                        .padding(.bottom, 15)

                }
            }

        }
        .sliderAlert(isShowing: $isShowingAlert)
        .onAppear {
            DispatchQueue.main.async {
//                mapManager.shelters.removeAll()
//                mapManager.shelters = SqliteManager().getSheltersAll(range: 30000)
//                print(mapManager.shelters)
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
                Text("距約\(Int(mapManager.mapShelter.distance))米, \(mapManager.mapShelter.category), 地下\(mapManager.mapShelter.underFloor)樓")
                    .font(.system(size: 18).bold())
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: mapManager.mapShelter)
                    .overlay(alignment: .leading) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 19).bold())
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
        .overlay {
            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(scheme == .dark ? .white : .black)
        }
        
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
                    MapAnnotationView(shelter: shelter)
                        .scaleEffect(mapManager.mapShelter == shelter ? 1.5 : 0.8).animation(Animation.easeInOut(duration: 0.2))
                        .scaleEffect(CGSize(width: mapManager.mapShelter == shelter ? (isBreathing ? 1.09 : 1) : 1, height: mapManager.mapShelter == shelter ? (isBreathing ? 0.94 : 1) : 1), anchor: .center).animation(Animation.easeInOut(duration: 0.8))
                        .onReceive(timer) { input in
                            isBreathing.toggle()
                            isShakeAnimating.toggle()
                            mapManager.checkCenter()
                        }
//                        .opacity(shelter.capacity == "0" ? 0 : 1)
                        .offset(y: -10)
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

        }
    }
    
    private var shelterPreviewStack: some View {
        ZStack {
            ForEach(mapManager.shelters) { shelter in
                
                if mapManager.mapShelter == shelter {
                    ShelterPreview(shelter: shelter)
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
