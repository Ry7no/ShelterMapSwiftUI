//
//  LottieView.swift
//  ShelterMapSwiftUI
//
//  Created by @Ryan on 2022/8/14.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    typealias UIViewType = UIView
    var filename: String
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = AnimationView()
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
    }

}

extension Double {
    func rounding(toDecimal decimal: Int) -> Double {
        let numberOfDigits = pow(10.0, Double(decimal))
        return (self * numberOfDigits).rounded(.toNearestOrAwayFromZero) / numberOfDigits
    }
    
    func string(fractionDigits:Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: self as NSNumber) ?? "\(self)"
    }
}
