//
//  SearchGroupViewModel.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 16/06/2021.
//

import Combine

final class SearchGroupViewModel: ObservableObject {
    @Published var visibleGroups: [Group] = []
    @Published var query: String = ""
    
    func loadData() {
        visibleGroups = Array(0...20).map { _ in Mocks.group }
    }
}
