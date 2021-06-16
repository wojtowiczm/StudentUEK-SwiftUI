//
//  GradientBackgroundModifier.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 16/06/2021.
//

import SwiftUI

struct GradientBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    var gradientColors: [UIColor] {
        return [
            UIColor.white.withAlphaComponent(0.5),
            UIColor.systemPurple.withAlphaComponent(colorScheme == .dark ? 0.5 : 0.2),
            UIColor.systemTeal
        ]
    }
    
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: gradientColors.map(Color.init)), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .blur(radius: 40)
            content
            SafeAreaBlurView()
        }
    }
}
