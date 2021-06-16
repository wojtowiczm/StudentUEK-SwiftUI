//
//  SearchView.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 16/06/2021.
//

import SwiftUI

struct SearchGroupView: View {
    @StateObject var viewModel: SearchGroupViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    SearchBar(searchText: $viewModel.query)
                    ForEach(viewModel.visibleGroups) { group in
                        GroupCell(group: group)
                    }
                }
                .navigationBarTitle("searchTitle")
                .onAppear(perform: viewModel.loadData)
            }
            .modifier(GradientBackgroundModifier())
        }
    }
}

struct SearchGroupView_Previews: PreviewProvider {
    static var previews: some View {
        SearchGroupView(viewModel: .init())
    }
}
