//
//  SubjectType.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 16/06/2021.
//

import Foundation

enum SubjectType: String, CaseIterable {
    case discourse
    case excercise
    case lecture
    
    var localized: String {
        switch self {
        case .lecture:
            return "lectureFilter".localized
        case .discourse:
            return "discourseFilter".localized
        case .excercise:
            return "exercisesFilter".localized
        }
    }
}

extension SubjectType: Identifiable {
    var id: String { rawValue }
}
