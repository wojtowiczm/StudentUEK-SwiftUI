//
//  ScheduleGrouper.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import Foundation

protocol ScheduleSectionGroupingLogic {
    func groupedSections(from schedule: [Subject]) -> [ScheduleSection]
}

final class ScheduleGrouper: ScheduleSectionGroupingLogic {
    
    func groupedSections(from schedule: [Subject]) -> [ScheduleSection] {
        let grouped = Dictionary(grouping: schedule) { $0.dateString! }
        let sections = grouped.map { (startTime, subjects) -> ScheduleSection in
            let sortedSubject = subjects.sorted { $0.startTime! < $1.startTime! }
            return ScheduleSection(title: startTime, subjects: sortedSubject)
        }
        .filter { !$0.subjects.isEmpty }
        
        let result = sections.sorted { $0.subjects.first!.startTime! < $1.subjects.first!.startTime! }
        return result
    }
}
