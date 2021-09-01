//
//  Mocks.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import Foundation

enum Mocks {
    static let subject = Subject(dateString: "2021-01-02", dayName: "Poniedziałek", startTime: Date(), startTimeString: "12:30", endTime: Date(), endTimeString: "14:30", name: "Matematyka", teacher: "Wiliusz", place: "Paw A", type: .excercise, note: "blah blah blah blah", moodleLink: .init(), sourceType: .init(), userNote: .init())
    
    static var group: Group { Group(name: "Test group", id: UUID().uuidString, type: "") }
}
