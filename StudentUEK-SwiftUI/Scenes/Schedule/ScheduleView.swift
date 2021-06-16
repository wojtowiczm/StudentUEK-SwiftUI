//
//  ScheduleView.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import SwiftUI
import Combine

struct ScheduleView: View {
    @StateObject var viewModel: ScheduleViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    SearchBar(searchText: $viewModel.query)
                    ForEach(viewModel.visibleSections) { section in
                        ScheduleSectionView(section: section)
                    }
                }
                .navigationBarTitle("mainScheduleTitle")
                .onAppear(perform: viewModel.loadData)
            }
            .modifier(GradientBackgroundModifier())
            .navigationBarItems(
                leading:
                    Button(viewModel.filterButtonTitle) {
                        withAnimation { viewModel.showFilters.toggle() }
                    },
                trailing: Button(action: { withAnimation { viewModel.showAddSubject = true } }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $viewModel.showAddSubject) {
                Text("destination")
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

