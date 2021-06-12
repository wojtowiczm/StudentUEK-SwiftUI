//
//  ScheduleViewModel.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import Combine
import SwiftUI

final class ScheduleViewModel: ObservableObject {
    @Published var sections: [ScheduleSection] = []
    @Published var filterButtonTitle: String = "Filtry"
    @Published var showFilters: Bool = false
    @Published var query: String = "" {
        didSet { filter() }
    }
    
    @Published var subjectTypes: Set<SubjectType> = Set(SubjectType.allCases) {
        didSet {
            filter()
            updateFiltersCount()
        }
    }
    
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
            .sink { [weak self] in
                self?.fullSchedule = $0
                self?.sections = $0
            }
            .store(in: &cancellableBag)
    }
    
    func filter() {
        withAnimation {
            sections = fullSchedule.compactMap {
                var new = $0
                if !query.isEmpty {
                    new.subjects = $0.subjects.filter {
                        $0.contains(searchText: query.lowercased()) && subjectTypes.contains($0.type!)
                    }
                }
                return new.subjects.isEmpty ? nil : new
            }
        }
    }
    
    private func updateFiltersCount() {
        let filtersCount = SubjectType.allCases.count - subjectTypes.count
        filterButtonTitle = filtersCount != 0 ? "Filtry (\(filtersCount))" : "Filtry"
    }
}
