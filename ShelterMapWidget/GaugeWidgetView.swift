//
//  GaugeWidgetView.swift
//  ShelterMapWidgetExtension
//
//  Created by @Ryan on 2022/9/5.
//

import SwiftUI

struct GaugeWidgetView: View {
    
    @Environment(\.colorScheme) var scheme

    @State var shadowColor: Color = .blue.opacity(0.6)
    
    func colorMix(percent: Int) -> Color {
        let p = Double(percent)
        let tempG = (70.0-p)/100
        let g: Double = tempG < 0 ? 0 : tempG
        let tempR = 1+(p-100.0)/100.0
        let r: Double = tempR < 0 ? 0 : tempR
        return Color.init(red: r, green: g, blue: 0.5)
    }
    
    
    func tick(at tick: Int, totalTicks: Int) -> some View {
        let percent = (tick * 100) / totalTicks
        let startAngle = coveredRadius/2 * -1
        let stepper = coveredRadius/Double(totalTicks)
        let rotation = Angle.degrees(startAngle + stepper * Double(tick))
        return VStack {
                   Rectangle()
                .fill(scheme == .dark ? Color(uiColor: .lightGray) : colorMix(percent: percent))
                       .frame(width: tick % 2 == 0 ? 5 : 3,
                              height: tick % 2 == 0 ? 20 : 10)//alternet small big dash
//                       .shadow(color: shadowColor, radius: 1, x: 1, y: 1)
            
                   Spacer()
           }.rotationEffect(rotation)
    }
    
    func tickText(at tick: Int, text: String) -> some View {
        let percent = (tick * 100) / tickCount
        let startAngle = coveredRadius/2 * -1 + 90
        let stepper = coveredRadius/Double(tickCount)
        let rotation = startAngle + stepper * Double(tick)
        return Text(text)
            .foregroundColor(scheme == .dark ? Color(uiColor: .lightGray) : colorMix(percent: percent))
            .rotationEffect(.init(degrees: -1 * rotation), anchor: .center)
            .offset(x: -115, y: 0)
            .rotationEffect(Angle.degrees(rotation))
            .font(.system(size: 15, weight: .bold))
//            .shadow(color: shadowColor, radius: 1, x: 1, y: 1)
    }
    
    let coveredRadius: Double // 0 - 360°
    let maxValue: Int
    let steperSplit: Int
    
    private var tickCount: Int {
        return maxValue/steperSplit
    }
    
    @State var value: Double
    var body: some View {
        ZStack {
            Text("\(value, specifier: "%0.0f")")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(scheme == .dark ? .white : .blue)
                .offset(x: 0, y: 68)
            
            ForEach(0..<tickCount*2 + 1) { tick in
                self.tick(at: tick,
                          totalTicks: self.tickCount*2)
            }
            
            ForEach(0..<tickCount+1) { tick in
                self.tickText(at: tick, text: "\(self.steperSplit*tick)")
            }
            
            Needle()
                .fill(scheme == .dark ? .white : .blue)
                .frame(width: 100, height: 6)
                .offset(x: -55, y: 0)
                .rotationEffect(.init(degrees: getAngle(value: value)), anchor: .center)
//                .animation(.easeInOut(duration: 0.9))
                .animation(.spring(response: 1.5, dampingFraction: 1, blendDuration: 1))
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(scheme == .dark ? .white : .blue)
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(scheme == .dark ? Color(uiColor: .darkGray) : .white)
        }.frame(width: 185, height: 185, alignment: .center)
//            .background(.gray)
            
    }

    func getAngle(value: Double) -> Double {
        return (value/Double(maxValue))*coveredRadius - coveredRadius/2 + 90
    }
}

struct Needle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        return path
    }
}

//struct GaugeWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        GaugeWidgetView()
//    }
//}
