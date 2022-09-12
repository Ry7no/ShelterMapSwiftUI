//
//  MapAnnotationViewWidget.swift
//  ShelterMapWidgetExtension
//
//  Created by @Ryan on 2022/9/6.
//

import SwiftUI

struct MapAnnotationViewWidget: View {
    
    @Environment(\.colorScheme) var scheme
    
    @State var category: String
    @State var capacity: String
    
    @State private var annotationColorDigits = Color("darkRed")
    
    var body: some View {
        
        ZStack {
            
            Ellipse()
                .foregroundColor(.gray)
                .frame(width: 12, height: 5)
                .offset(y: 5)
            
            VStack(spacing: 0) {
                
                Text(category.prefix(2))
                    .font(.system(size: 12.5).bold())
                    .foregroundColor(annotationColorDigits)
                    .frame(width: 40, height: 40)
                    .background(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 3.5).foregroundColor(annotationColorDigits))
                
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(annotationColorDigits)
                    .frame(width: 7, height: 7)
                    .rotationEffect(Angle(degrees: 180))
                    .scaleEffect(x: 1.1, y: 0.7, anchor: .center)
                    .offset(y: -1)
                    .padding(.bottom, 40)
                
            }
            
            VStack {

                Text("容量")
                    .font(.system(size: 6, weight: .bold))
                    .foregroundColor(scheme == .dark ? .gray : Color(UIColor.lightGray))

                Text(capacity)
                    .font(.system(size: 7, weight: .bold))
                    .foregroundColor(scheme == .dark ? .black : .white)
                    

            }
            .padding(.vertical, 2.5)
            .padding(.horizontal, 4)
            .background(scheme == .dark ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .offset(x: -16, y: -6)
            
        }
//        .opacity(shelter.capacity == "0" ? 0 : 1)
        
    }
}

struct MapAnnotationViewWidget_Previews: PreviewProvider {
    static var previews: some View {
        MapAnnotationViewWidget(category: "大樓", capacity: "500")
    }
}
