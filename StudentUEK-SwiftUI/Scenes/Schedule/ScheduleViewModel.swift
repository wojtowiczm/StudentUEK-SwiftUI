//
//  ScheduleViewModel.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import Combine
import SwiftUI

final class ScheduleViewModel: ObservableObject {
    @Published var visibleSections: [ScheduleSection] = []
    @Published var filterButtonTitle: String = "Filtry"
    @Published var showFilters: Bool = false
    @Published var showAddSubject = false
    @Published var query: String = "" {
        didSet {
            withAnimation { showFilters = false }
            applyFilters()
        }
    }
    
    @Published var subjectTypes: Set<SubjectType> = Set(SubjectType.allCases) {
        didSet {
            applyFilters()
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
                self?.visibleSections = $0
            }
            .store(in: &cancellableBag)
    }
    
    func applySearch() {
        
    }
    
    func applyFilters() {
        visibleSections = fullSchedule.compactMap {
            var new = $0
            if subjectTypes.count != SubjectType.allCases.count {
                new.subjects = new.subjects.filter { subject in
                    subjectTypes.contains(subject.type!)
                }
            }
            if !query.isEmpty {
                new.subjects = new.subjects.filter { subject in
                    subject.contains(searchText: query.lowercased())
                }
            }
            return new.subjects.isEmpty ? nil : new
        }
    }
    
    private func updateFiltersCount() {
        let filtersCount = SubjectType.allCases.count - subjectTypes.count
        filterButtonTitle = filtersCount != 0 ? "Filtry (\(filtersCount))" : "Filtry"
    }
}
