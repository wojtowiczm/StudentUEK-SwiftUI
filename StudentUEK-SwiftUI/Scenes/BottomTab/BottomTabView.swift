//
//  BottomTabView.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 12/06/2021.
//

import SwiftUI
import UIKit

struct BottomTabView: View {
    @State var showScheduleFilters = false
    @StateObject var scheduleViewModel = ScheduleViewModel(scheduleLoader: ScheduleStoreMock(), grouper: ScheduleGrouper())
    
    var body: some View {
        ZStack {
            TabView {
                ScheduleView(viewModel: scheduleViewModel, showFilters: $showScheduleFilters)
                    .tabItem {
                        Label("mainScheduleTabBarTitle", systemImage: "star.fill")
                    }
            }
            .accentColor(.pink)
            VStack {
                Spacer()
                if showScheduleFilters {
                    FiltersView(showFilters: $showScheduleFilters, filters: $scheduleViewModel.subjectTypes)
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
