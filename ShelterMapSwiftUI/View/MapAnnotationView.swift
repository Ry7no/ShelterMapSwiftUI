//
//  MapAnnotationView.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/4.
//

import SwiftUI

struct MapAnnotationView: View {

    @EnvironmentObject private var mapManager: MapManager
    let shelter: Shelter
    
    @State private var annotationColorDigits2 = Color("Red1")
    @State private var annotationColorDigits3 = Color("Red2")
    @State private var annotationColorDigits4 = Color("Red3")
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 0) {
                
                Text(shelter.category.prefix(2))
                    .font(.system(size: 12.5).bold())
                    .foregroundColor(Int(shelter.capacity) ?? 0 < 99 ? annotationColorDigits2 : (Int(shelter.capacity) ?? 0 > 999 ? annotationColorDigits4 : annotationColorDigits3))
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 3.5).foregroundColor(Int(shelter.capacity) ?? 0 < 99 ? annotationColorDigits2 : (Int(shelter.capacity) ?? 0 > 999 ? annotationColorDigits4 : annotationColorDigits3)))
                
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Int(shelter.capacity) ?? 0 < 99 ? annotationColorDigits2 : (Int(shelter.capacity) ?? 0 > 999 ? annotationColorDigits4 : annotationColorDigits3))
                    .frame(width: 7, height: 7)
                    .rotationEffect(Angle(degrees: 180))
                    .scaleEffect(x: 1.1, y: 0.7, anchor: .center)
                    .offset(y: -1)
                    .padding(.bottom, 40)
                
            }
            
            VStack {

                Text("容量")
                    .font(.system(size: 6).bold())
                    .foregroundColor(Color(UIColor.lightGray))

                Text(shelter.capacity)
                    .font(.system(size: 6).bold())
                    .foregroundColor(.white)
                    

            }
            .padding(.vertical, 2.5)
            .padding(.horizontal, 4)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .offset(x: -15, y: -6)
            
        }
//        .opacity(shelter.capacity == "0" ? 0 : 1)
        
    }
}

//struct MapAnnotationView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapAnnotationView()
//    }
//}
