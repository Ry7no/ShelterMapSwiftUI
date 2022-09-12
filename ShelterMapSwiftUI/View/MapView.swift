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
    @EnvironmentObject private var mapManager: MapManager
    @EnvironmentObject private var sqliteManager: SqliteManager
    
    @Environment(\.colorScheme) var scheme
    
    @State var tracking: MapUserTrackingMode = .none
    @State var interaction: MapInteractionModes = .all
    @State var isExtending: Bool = false
    
    let timer = Timer.publish(every: 0.6, on: .main, in: .common).autoconnect()
    @State private var isBreathing: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var isUserCenter: Bool = false
    
    @State var searchingTimeRemaining = 10
    @State var showingSearchAlert = false
    
    @State var bottomPadding: CGFloat = 28
    
    @State private var isCircle: Bool = true
    
    var body: some View {
        
        ZStack {
            
            mapLayer
                .ignoresSafeArea()
            
            
            if let mapShelters = mapManager.shelters {
                
                if mapShelters.isEmpty || sqliteManager.shelters.isEmpty {
                    
                    ZStack(alignment: .bottomTrailing) {
                        
                        ProgressView()
                            .padding(.horizontal, 47)
                            .padding(.vertical, 55)
                            .tint(scheme == .dark ? .white : .black)
                            .scaleEffect(x: 2, y: 2, anchor: .center)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 3).foregroundColor(scheme == .dark ? .white : .black)
                            }
                            .onReceive(mapManager.timer) { input in
                                if locationManager.userPosition.latitude == 24.140793 {
                                    searchingTimeRemaining = 10
                                } else {
                                    
                                    if searchingTimeRemaining > 0 {
                                        print("@countdown")
                                        searchingTimeRemaining -= 1
                                    } else if searchingTimeRemaining == 0 {
                                        showingSearchAlert = true
                                    }
                                    
                                }
                                
                            }
                            .onAppear {
                                isExtending = false
                            }
                        
                        Text("\(searchingTimeRemaining)")
                            .font(.system(size: 12))
                            .padding(9)
                            .opacity(searchingTimeRemaining == 0 ? 0 : 1)
                        
                    }
                    //                    .opacity(searchingTimeRemaining > 10 ? 0 : 1)
                    .alert("附近搜尋不到相關避難設施", isPresented: $showingSearchAlert, actions: {
                        Button("重新搜尋") {
                            searchingTimeRemaining = 10
                            showingSearchAlert = false
                            sqliteManager.shelters.removeAll()
                            mapManager.shelters.removeAll()
                            DispatchQueue.main.async {
                                sqliteManager.getSheltersAll(range: sqliteManager.radius)
                                mapManager.shelters = sqliteManager.shelters
                                mapManager.mapShelter = Shelter(category: "請下拉選擇或點擊圖標", code: "", village: "", address: "", latitude: 0.0, longitude: 0.0, underFloor: "", capacity: "", office: "")
                                withAnimation {
                                    mapManager.mapRegion.center = self.locationManager.userPosition
                                    mapManager.mapRegion.span = MKCoordinateSpan(latitudeDelta: Double(sqliteManager.radius / 55000), longitudeDelta: Double(sqliteManager.radius / 55000))
                                }
                            }
                        }
                        
                        Button("調整範圍"){
                            withAnimation {
                                showingSearchAlert = false
                                searchingTimeRemaining = 15
                                self.isShowingAlert.toggle()
                                //                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                //                                    searchingTimeRemaining = 10
                                //                                }
                            }
                        }
                    }, message: {
                        Text("\n請調整搜尋半徑重新搜尋")
                    })
                    
                    
                } else {
                    VStack(alignment: .center) {
                        
                        header
                            .padding()
                            .opacity(locationManager.isFollow ? 0 : 1)
                        
                        
                        Spacer()
                        
                        HStack {
                            
                            HStack(spacing: (UIScreen.main.bounds.width - 280) / 4 ) {
                                
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
                                
                                HStack(spacing: (UIScreen.main.bounds.width - 280) / 4) {
                                    
                                    Button {
                                        
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
                                            .background(content: {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .foregroundColor(locationManager.isFollow ? .blue : .clear)
                                            })
                                            .frame(width: 40, height: 40)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 2).foregroundColor(scheme == .dark ? .white : .black)
                                            }
                                            .onTapGesture {
                                                locationManager.getLocation()
                                                mapManager.resetCamera()
                                            }
                                            .onLongPressGesture(minimumDuration: 0.1) {
                                                
                                                withAnimation(.easeInOut) {
                                                    locationManager.isFollow.toggle()
                                                }
                                                
                                                DispatchQueue.main.async {
                                                    if locationManager.isFollow {
                                                        tracking = .follow
                                                        interaction = .zoom
                                                        locationManager.startMonitoringLocation()
                                                    } else {
                                                        tracking = .none
                                                        interaction = .all
                                                        locationManager.stopMonitoringLocation()
                                                    }
                                                }
                                                
                                            }
                                    }
                                    
                                    Button {
                                        locationManager.getLocation()
                                        withAnimation {
                                            self.isShowingAlert.toggle()
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            locationManager.stopMonitoringLocation()
                                        }
                                        
                                    } label: {
                                        Image(systemName: "barometer")
                                            .font(.system(size: 18).bold())
                                            .rotationEffect(Angle(degrees: isShowingAlert ? 360 : 0))
                                            .scaleEffect(isShowingAlert ? 1.25 : 1)
                                            .scaledToFit()
                                            .foregroundColor(scheme == .dark ? .white : .black)
                                            .padding()
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
                                    .opacity(locationManager.isFollow ? 0 : 1)
                                    
                                    Button {
                                        locationManager.getLocation()
                                        sqliteManager.shelters.removeAll()
                                        mapManager.shelters.removeAll()
                                        DispatchQueue.main.async {
                                            sqliteManager.getSheltersAll(range: sqliteManager.radius)
                                            mapManager.shelters = sqliteManager.shelters
                                            mapManager.mapShelter = Shelter(category: "請下拉選擇或點擊圖標", code: "", village: "", address: "", latitude: 0.0, longitude: 0.0, underFloor: "", capacity: "", office: "")
                                            withAnimation {
                                                mapManager.mapRegion.center = self.locationManager.userPosition
                                                mapManager.mapRegion.span = MKCoordinateSpan(latitudeDelta: Double(sqliteManager.radius / 55000), longitudeDelta: Double(sqliteManager.radius / 55000))
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                locationManager.stopMonitoringLocation()
                                            }
                                        }
                                        
                                        self.isExtending = false
                                        
                                    } label: {
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                            .font(.system(size: 15).bold())
                                            .rotationEffect(Angle(degrees: 90))
                                            .scaledToFit()
                                            .foregroundColor(scheme == .dark ? .white : .black)
                                            .padding()
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
                                    .opacity(locationManager.isFollow ? 0 : 1)
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
                            .opacity(mapManager.mapShelter.category == "請下拉選擇或點擊圖標" ? 0 : 1)
                            .opacity(locationManager.isFollow ? 0 : 1)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                        
                        shelterPreviewStack
                            .padding(.horizontal, 10)
                            .padding(.bottom, 15)
                            .opacity(locationManager.isFollow ? 0 : 1)
                        
                    }
                    
                }
            }
            
            if isCircle {
                
                GaugeView(coveredRadius: 225, maxValue: 100, steperSplit: 10, value: $locationManager.speedDouble)
                    .padding(.horizontal, 55)
                    .padding(.top, 52)
                    .padding(.bottom, bottomPadding)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    })
                    .overlay {
                        Image(systemName: "triangle.fill")
                            .font(.system(size: 10).bold())
                            .rotationEffect(Angle(degrees: 180))
                            .foregroundColor(scheme == .dark ? .white : .blue)
                            .scaleEffect(x: 1.1, y: 0.8, anchor: .center)
                            .offset(y: bottomPadding/2 + 123)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 4).foregroundColor(scheme == .dark ? .white : .blue)
                    }
                    .offset(y: -(136 + bottomPadding))
                    .onTapGesture(perform: {
                        withAnimation(.easeInOut) {
                            isCircle.toggle()
                        }
                    })
                    .opacity(locationManager.isFollow ? 1 : 0)
                
            } else {
                
                HStack {
                    
                    Text("\(locationManager.speedInt)")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(scheme == .dark ? .white : .blue)
                    
                    Text("km/h")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(scheme == .dark ? .white : .blue)
                        .offset(x: -2, y: 10)
                    
                }
                .padding(.horizontal, 15)
                .background(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)
                })
                .overlay {
                    Image(systemName: "triangle.fill")
                        .font(.system(size: 8).bold())
                        .foregroundColor(scheme == .dark ? .white : .blue)
                        .scaleEffect(x: 1.1, y: 0.8, anchor: .center)
                        .offset(y: -40)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 4).foregroundColor(scheme == .dark ? .white : .blue)
                }
                .onTapGesture(perform: {
                    withAnimation(.easeInOut) {
                        isCircle.toggle()
                    }
                })
                .offset(y: 60)
                .opacity(locationManager.isFollow ? 1 : 0)
            }
            
        }
        .sliderAlert(isShowing: $isShowingAlert)
        .onAppear {
            DispatchQueue.main.async {
                if sqliteManager.shelters.isEmpty {
                    DispatchQueue.main.async {
                        sqliteManager.getSheltersAll(range: sqliteManager.radius)
                        mapManager.shelters = sqliteManager.shelters
                        mapManager.mapShelter = Shelter(category: "請下拉選擇或點擊圖標", code: "", village: "", address: "", latitude: 0.0, longitude: 0.0, underFloor: "", capacity: "", office: "")
                        withAnimation {
                            mapManager.mapRegion.center = self.locationManager.userPosition
                            mapManager.mapRegion.span = MKCoordinateSpan(latitudeDelta: Double(sqliteManager.radius / 55000), longitudeDelta: Double(sqliteManager.radius / 55000))
                        }
                    }
                }
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
                Text(mapManager.mapShelter.category == "請下拉選擇或點擊圖標" ? "\(mapManager.mapShelter.category)" : "距約\(Int(mapManager.mapShelter.distance))米, \(mapManager.mapShelter.category), 地下\(mapManager.mapShelter.underFloor)樓")
                    .font(.system(size: 16).bold())
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
                    .overlay(alignment: .trailing) {
                        VStack {
                            Text("\(mapManager.shelters.count)")
                                .font(.system(size: 10).bold())
                                .padding(6)
                                .foregroundColor(scheme == .dark ? .white : .black)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 6).stroke(lineWidth: 1.5).foregroundColor(scheme == .dark ? .white : .black).opacity(mapManager.showShelterList ? 0 : 1)
                                }
                                .scaleEffect(mapManager.showShelterList ? 1.5 : 1)
                        }
                        .padding(.trailing, 12)
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
                interactionModes: interaction,
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
                        .opacity(locationManager.isFollow ? 0 : 1)
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
