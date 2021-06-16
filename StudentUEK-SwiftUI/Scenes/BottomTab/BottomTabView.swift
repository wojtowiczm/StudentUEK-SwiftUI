//
//  BottomTabView.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 12/06/2021.
//

import SwiftUI
import UIKit

struct BottomTabView: View {
    @StateObject private var scheduleViewModel = ScheduleViewModel(scheduleLoader: ScheduleStoreMock(), grouper: ScheduleGrouper())
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var seachGroupViewModel = SearchGroupViewModel()
    @State private var selectedTab = 1
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                SearchGroupView(viewModel: seachGroupViewModel)
                    .tabItem {
                        Label("searchTitle", systemImage: "magnifyingglass")
                    }
                    .tag(0)
                ScheduleView(viewModel: scheduleViewModel)
                    .tabItem {
                        Label("mainScheduleTabBarTitle", systemImage: "star.fill")
                    }
                    .tag(1)
                SettingsView(viewModel: settingsViewModel)
                    .tabItem {
                        Label("settingsTabBarTitle", systemImage: "gearshape.fill")
                    }
                    .tag(2)
            }
            VStack {
                Spacer()
                FiltersView(showFilters: $scheduleViewModel.showFilters, filters: $scheduleViewModel.subjectTypes)
            }
            .offset(y: scheduleViewModel.showFilters ? 0 : 400)
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
