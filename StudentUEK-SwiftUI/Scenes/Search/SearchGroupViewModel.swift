//
//  SearchGroupViewModel.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 16/06/2021.
//

import Combine
import Foundation
import SwiftUI

final class SearchGroupViewModel: ObservableObject {
    @Published var visibleGroups: [Group] = []
    @Published var query: String = "" {
        didSet { withAnimation { applyFilters() } }
    }
    
    private var groups: [Group] = []
    
    let apiService = ApiService<[Group]>()
    
    private var cancellableBag: Set<AnyCancellable> = []
    
    func loadData() {
        apiService
            .loadAllGroups()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { print($0) }) { [weak self] groups in
                self?.groups = groups
                withAnimation { self?.visibleGroups = groups }
            }
            .store(in: &cancellableBag)
    }
    
    private func applyFilters() {
        if !query.isEmpty {
            visibleGroups = groups.filter { $0.name.lowercased().contains(query.lowercased()) }
        } else {
            visibleGroups = groups
        }
    }
}

