//
//  ShelterPreview.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/5.
//

import SwiftUI

struct ShelterPreview: View {
    
    @EnvironmentObject private var mapManager: MapManager
    @Environment(\.colorScheme) var scheme
    
    @State private var annotationColorDigits2 = Color("Red1")
    @State private var annotationColorDigits3 = Color("Red2")
    @State private var annotationColorDigits4 = Color("Red3")
    
    let shelter: Shelter
//    let shelter = Shelter(category: "大樓", code: "BB00356", village: "光大里", address: "臺中市北區光大里中清路一段80號", latitude: "24.153048", longitude: "120.677711", underFloor: "2", capacity: "1254", office: "第二分局", remarks: "s", distance: 85.0)

    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            HStack(alignment: .bottom, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 5) {

                    Text("")
                        .frame(height: 15)
                    
                    HStack(alignment: .top, spacing: 0) {
                        Text("地址：")
                            .font(.system(size: 14)).bold()
                        Text(shelter.address)
                            .font(.system(size: 14))
                    }
                    
                    HStack(alignment: .top, spacing: 0) {
                        Text("位置：")
                            .font(.system(size: 14)).bold()
                        Text("位於地下 \(shelter.underFloor) 層樓")
                            .font(.system(size: 14))
                    }
                    
                    HStack(alignment: .top, spacing: 0) {
                        Text("容量：")
                            .font(.system(size: 14)).bold()
                        Text("可容納 \(shelter.capacity) 人")
                            .font(.system(size: 14))
                    }
                    
                    HStack(alignment: .top, spacing: 0) {
                        Text("距離：")
                            .font(.system(size: 14)).bold()
                        Text("直線距約 \(Int(shelter.distance)) 米")
                            .font(.system(size: 14))
                    }

                }
                
                
                VStack(spacing: 20) {
                    
                    Button {
                        mapManager.openMapsAppWithDirections(to: shelter.coordinates, destinationName: shelter.address)
                    } label: {
                        Text("導航前往")
                            .font(.system(size: 15).bold())
                    }
                    
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
            )
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(scheme == .dark ? .white : .black)
            }
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 5, y: 5)
            
            Text(shelter.category)
                .font(.system(size: 22).bold())
                .foregroundColor(scheme == .dark ? .white : Int(shelter.capacity)! < 99 ? annotationColorDigits2 : (Int(shelter.capacity)! > 999 ? annotationColorDigits4 : annotationColorDigits3))
                .padding(.horizontal)
                .padding(.vertical, 10)
//                .background {
//                    Color.white.opacity(0.8)
//                }
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 4)
                        .foregroundColor(Int(shelter.capacity)! < 99 ? annotationColorDigits2 : (Int(shelter.capacity)! > 999 ? annotationColorDigits4 : annotationColorDigits3))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 4)
                        .foregroundColor(.white.opacity(scheme == .dark ? 0.3 : 0))
                }
                .padding(.bottom, 10)
                .rotationEffect(Angle(degrees: -3))
                .animation(Animation.easeInOut(duration: 0.4))
                .offset(x: 20, y: -20)
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 5, y: 5)
            
        }
        
        
    }
}

//struct ShelterPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        ShelterPreview()
//    }
//}
