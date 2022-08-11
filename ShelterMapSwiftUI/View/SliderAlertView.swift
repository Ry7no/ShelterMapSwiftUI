//
//  SliderAlertView.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/11.
//

import SwiftUI
import MapKit

struct SliderAlertView<Presenting>: View where Presenting: View {
    
    @EnvironmentObject var sqliteManager: SqliteManager
    @EnvironmentObject private var mapManager: MapManager
    @EnvironmentObject private var locationManager: LocationManager
    
    @Environment(\.colorScheme) var scheme
    
    @Binding var isShowing: Bool
    let presenting: Presenting
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                
                HStack {
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                .background(Rectangle().fill(.thinMaterial.opacity(0.85)).blur(radius: 3)
                    .onTapGesture {
                    isShowing.toggle()
                })
                .opacity(self.isShowing ? 1 : 0)
                .ignoresSafeArea()
                    
                VStack (alignment: .leading) {
                    
                    HStack {
                        Text("搜尋範圍(半徑)")
                            .font(.system(size: 18).bold())
//                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        Text("\(String(format: "%.0f", sqliteManager.radius))m")
                            .font(.system(size: 16).bold())
//                            .foregroundColor(.green)
                        
                    }
                    
                    Slider(value: $sqliteManager.radius, in: 100...900)
                        .accentColor(Color("Red3"))
                    
                    HStack {
                        Button {
                            isShowing.toggle()
                            sqliteManager.shelters.removeAll()
                            mapManager.shelters.removeAll()
                            DispatchQueue.main.async {
                                sqliteManager.getSheltersAll(range: sqliteManager.radius)
                                mapManager.shelters = sqliteManager.shelters
                                withAnimation {
                                    mapManager.mapRegion.center = self.locationManager.userPosition
                                    mapManager.mapRegion.span = MKCoordinateSpan(latitudeDelta: Double(sqliteManager.radius / 55000), longitudeDelta: Double(sqliteManager.radius / 55000))
                                }
                            }
                        } label: {
                            Text("修改")
                                .font(.system(size: 16).bold())
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        }
                        .tint(Color("Red3"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.regular)
                        
                        Button {
                            isShowing.toggle()
                        } label: {
                            Text("取消")
                                .font(.system(size: 16).bold())
                                .foregroundColor(scheme == .dark ? .red : .white)
                                .padding(.horizontal)
                        }
                        .tint(scheme == .dark ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.regular)

                    }

                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10).fill(.thinMaterial)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 3)
                }
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.25
                )
                .opacity(self.isShowing ? 1 : 0)
                
            }
        }
    }
}

extension View {

    func sliderAlert(isShowing: Binding<Bool>) -> some View {
        SliderAlertView(isShowing: isShowing,
                       presenting: self)
    }

}

