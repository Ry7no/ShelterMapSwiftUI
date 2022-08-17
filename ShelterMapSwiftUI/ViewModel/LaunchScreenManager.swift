//
//  LaunchScreenManager.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/16.
//

import Foundation
import SwiftUI

enum LaunchScreenPhase {
    case first
    case second
    case completed
}

final class LaunchScreenManager: ObservableObject {
    
    @Published private(set) var state: LaunchScreenPhase = .first
    
    func dismiss(){

        self.state = .second

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.44) {
            
            withAnimation(.easeInOut) {
                self.state = .completed
            }

        }
    }
    
}
