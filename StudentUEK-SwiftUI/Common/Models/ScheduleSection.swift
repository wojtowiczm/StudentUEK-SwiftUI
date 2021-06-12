//
//  ScheduleSection.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import Foundation

struct ScheduleSection: Identifiable {
    let id = UUID()
    let title: String
    var subjects: [Subject]
}
