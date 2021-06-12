//
//  BottomTabView.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 12/06/2021.
//

import SwiftUI
import UIKit

struct BottomTabView: View {
    @StateObject var scheduleViewModel = ScheduleViewModel(scheduleLoader: ScheduleStoreMock(), grouper: ScheduleGrouper())
    @StateObject var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        ZStack {
            TabView {
                ScheduleView(viewModel: scheduleViewModel)
                    .tabItem {
                        Label("mainScheduleTabBarTitle", systemImage: "star.fill")
                    }
        
                SettingsView(viewModel: settingsViewModel)
                    .tabItem {
                        Label("settingsTabBarTitle", systemImage: "gear")
                    }
            }
            if scheduleViewModel.showFilters {
                VStack {
                    Spacer()
                    FiltersView(showFilters: $scheduleViewModel.showFilters, filters: $scheduleViewModel.subjectTypes)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .ignoresSafeArea()
        .accentColor(.pink)
    }
}
struct BottomTabView_Previews: PreviewProvider {
    static var previews: some View {
        BottomTabView()
    }
}
