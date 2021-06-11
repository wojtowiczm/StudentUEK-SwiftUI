//
//  ScheduleViewModel.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import Combine

final class ScheduleViewModel: ObservableObject {
    @Published var sections: [ScheduleSection] = []
    @Published var query: String = ""
    
    private let scheduleLoader: ScheduleLocalStore
    private let grouper: ScheduleSectionGroupingLogic
    
    private var fullSchedule: [ScheduleSection] = []
    private var cancellableBag: Set<AnyCancellable> = []
    
    init(scheduleLoader: ScheduleLocalStore, grouper: ScheduleSectionGroupingLogic) {
        self.scheduleLoader = scheduleLoader
        self.grouper = grouper
    }
    
    func loadData() {
        scheduleLoader.fetchStoredSchedule()
            .map(grouper.groupedSections)
            .assign(to: \.sections, on: self)
            .store(in: &cancellableBag)
        }
    
    func filter() {
        sections = fullSchedule.compactMap {
            var new = $0
            if !query.isEmpty {
                new.subjects = $0.subjects.filter { $0.contains(searchText: query.lowercased()) }
            }
            return new.subjects.isEmpty ? nil : new
        }
    }
}
