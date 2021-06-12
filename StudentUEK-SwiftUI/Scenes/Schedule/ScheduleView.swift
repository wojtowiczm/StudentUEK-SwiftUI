//
//  ScheduleView.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import SwiftUI
import Combine

struct ScheduleView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ScheduleViewModel
    
    var gradientColors: [UIColor] {
        return [
            UIColor.white.withAlphaComponent(0.7),
            UIColor.systemPurple.withAlphaComponent(0.3),
            UIColor.systemPink.withAlphaComponent(colorScheme == .dark ? 0.5 : 0.3),
            UIColor.systemPurple.withAlphaComponent(colorScheme == .dark ? 0.5 : 0.3),
            UIColor.systemTeal
        ]
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: gradientColors.map(Color.init)), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                        .blur(radius: 40)
                    ScrollView {
                        LazyVStack {
                            SearchBar(searchText: $viewModel.query)
                            ForEach(viewModel.sections) { section in
                                ScheduleSectionView(section: section)
                            }
                        }
                        .navigationBarTitle("mainScheduleTitle")
                        .onAppear(perform: viewModel.loadData)
                    }
                    SafeAreaBlurView()
                }
                .navigationBarItems(
                    leading:
                        Button(viewModel.filterButtonTitle) {
                            withAnimation {
                                viewModel.showFilters.toggle()
                            }
                        },
                    trailing: NavigationLink(destination: Text("Destination")) {
                        Image(systemName: "plus")
                    }
                )
            }
        }
    }
}

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
