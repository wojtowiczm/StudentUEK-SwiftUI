//
//  SafeAreaBlurView.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 12/06/2021.
//

import SwiftUI

struct SafeAreaBlurView: View {
    private struct OffsetPreferenceKey: PreferenceKey {
        static let defaultValue: Int = 0
        static func reduce(value: inout Int, nextValue: () -> Int) {
            value = nextValue()
        }
    }
    
    private struct BlurView: UIViewRepresentable {
        let effect: UIVisualEffect = UIBlurEffect(style: .regular)
        func makeUIView(context: Context) -> UIVisualEffectView {
            UIVisualEffectView(effect: effect)
        }
        
        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
    }

    
    @State var blurTop = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if blurTop {
                    BlurView()
                        .frame(maxWidth: .infinity, maxHeight: geometry.safeAreaInsets.top)
                }
                Spacer()
                BlurView()
                    .frame(maxWidth: .infinity, maxHeight: geometry.safeAreaInsets.bottom)
            }
            .preference(key: OffsetPreferenceKey.self, value: Int(geometry.safeAreaInsets.top))
            .ignoresSafeArea()
            .onPreferenceChange(OffsetPreferenceKey.self) { value in
                withAnimation {
                    blurTop = value < 90
                }
            }
        }
    }
}

struct SafeAreaBlurView_Previews: PreviewProvider {
    static var previews: some View {
        SafeAreaBlurView()
    }
}

