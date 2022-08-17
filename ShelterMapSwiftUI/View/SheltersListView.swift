//
//  SheltersListView.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/5.
//

import SwiftUI

struct SheltersListView: View {
    
//    @ObservedObject var mapManager = MapManager()
    @EnvironmentObject private var mapManager: MapManager
    @Environment(\.colorScheme) var scheme
    
    private var annotationColorDigits2 = Color("Red1")
    private var annotationColorDigits3 = Color("Red2")
    private var annotationColorDigits4 = Color("Red3")
//
//    let shelters: [Shelter] = [
//        Shelter(category: "大樓", code: "BB00356", village: "光大里", address: "臺中市北區光大里中清路一段80號", latitude: "24.153048", longitude: "120.677711", underFloor: "2", capacity: "1254", office: "第二分局", remarks: "s", distance: 85.0),
//        Shelter(category: "大樓", code: "BB00356", village: "光大里", address: "臺中市北區光大里中清路一段80號", latitude: "24.153048", longitude: "120.677711", underFloor: "2", capacity: "1254", office: "第二分局", remarks: "s", distance: 908.0)
//    ]

    var body: some View {
        List {
            ForEach(mapManager.shelters) { shelter in
                Button {
                    mapManager.showNextShelter(shelter: shelter)
                } label: {
                    listRowView(shelter: shelter)
                        
                }
                .padding(.vertical, 4)
                .listRowBackground(mapManager.mapShelter == shelter ? Color("Red1").opacity(scheme == .dark ? 0.5 : 0.3) : Color.clear)
                
            }
        }
        .listStyle(PlainListStyle())
    }
}

extension SheltersListView {
    
    private func listRowView(shelter: Shelter) -> some View {
        HStack(spacing: 15) {
            
            HStack {
                Spacer(minLength: 0.5)
                Text("\(Int(shelter.distance))")
                    .font(.system(size: 13.5).bold())
                    .foregroundColor(.white)
                Spacer(minLength: 3)
                Text("m")
                    .font(.system(size: 14).bold())
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 5)
            .frame(width: Int(shelter.distance) > 99 ? 55 : 46, height: 46, alignment: .trailing)
            .background(Int(shelter.capacity)! < 99 ? annotationColorDigits2 : (Int(shelter.capacity)! > 999 ? annotationColorDigits4 : annotationColorDigits3))
            .cornerRadius(10)

            VStack(alignment: .leading) {
                HStack {
                    Text(shelter.underFloor == "0" ? "\(shelter.category) - 地上層" : "\(shelter.category) - 地下 \(shelter.underFloor) 樓")
                        .font(.system(size: 15).bold())

                    Text("[ 可容納\(shelter.capacity)人 ]")
                        .font(.system(size: 11).bold())
                        .foregroundColor(mapManager.mapShelter == shelter ? .white.opacity(scheme == .dark ? 0.8 : 1) : .gray)
                }
                .padding(.bottom, 0.5)
                
                Text(shelter.address)
                    .font(.system(size: 12))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}

struct SheltersListView_Previews: PreviewProvider {
    static var previews: some View {
        SheltersListView()
    }
}
