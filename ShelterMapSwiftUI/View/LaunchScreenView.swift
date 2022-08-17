//
//  LaunchScreenView.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/14.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    private let timer = Timer.publish(every: 0.35, on: .main, in: .common).autoconnect()
    @State private var firstPhaseIsAnimating: Bool = false
    @State private var secondPhaseIsAnimating: Bool = false
    
    var body: some View {
        
        ZStack {
            
            Color.white.ignoresSafeArea()

            LinearGradient(gradient: Gradient(colors: [
                Color.black.opacity(0.8),
                Color.black
            ]), startPoint: UnitPoint(x: -1, y: 0), endPoint: UnitPoint(x: 0.9, y: 0.9))
            .ignoresSafeArea()
            .opacity(secondPhaseIsAnimating ? 0.9 : 1)
  
            Image("ShelterLogo")
                .resizable()
                .frame(width: UIScreen.main.bounds.width/4.5,
                       height: UIScreen.main.bounds.width/4.5)
                .rotationEffect(Angle(degrees: secondPhaseIsAnimating ? 15 : 0))
                .scaleEffect(secondPhaseIsAnimating ? 1.2 : 1)
            
        }
        .onReceive(timer) { input in
            switch launchScreenManager.state {
            case .first:
                withAnimation(.spring()) {
                    firstPhaseIsAnimating.toggle()
                }
            case .second:
                withAnimation(.easeInOut) {
                    secondPhaseIsAnimating.toggle()
                }
            default: break
            }
            
        }
    }
}


struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
