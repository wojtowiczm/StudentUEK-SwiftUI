//
//  BottomTabView.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 12/06/2021.
//

import SwiftUI
import UIKit

struct BottomTabView: View {
    var body: some View {
        TabView {
            ScheduleView(viewModel: ScheduleViewModel(scheduleLoader: ScheduleStoreMock(), grouper: ScheduleGrouper()))
                .tabItem {
                    Label("mainScheduleTabBarTitle", systemImage: "star.fill")
                }
                .accentColor(.red)
        }
    }
}
struct BottomTabView_Previews: PreviewProvider {
    static var previews: some View {
        BottomTabView()
    }
}
