//
//  StudentUEK_SwiftUIApp.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import SwiftUI
import UIKit

@main
struct StudentUEK_SwiftUIApp: App {
    init() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().isOpaque = true
        
        UINavigationBar.appearance().isOpaque = true
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    var body: some Scene {
        WindowGroup {
            BottomTabView()
        }
    }
}

