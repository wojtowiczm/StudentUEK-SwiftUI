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
    @Published var query: String = ""
    
    let apiService = ApiService<[Group]>()
    
    private var cancellableBag: Set<AnyCancellable> = []
    
    func loadData() {
        apiService
            .loadAllGroups()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { print($0) }) { [weak self] groups in
                withAnimation { self?.visibleGroups = groups }
            }
            .store(in: &cancellableBag)
    }
}

