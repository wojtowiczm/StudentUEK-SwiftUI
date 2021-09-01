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
    
    init?(string: String) {
        let caseInsensitiveStr = string.lowercased()
        if caseInsensitiveStr.contains("wykład") {
            self = .discourse
        } else if caseInsensitiveStr.contains("ćwiczenia") {
            self = .excercise
        } else if caseInsensitiveStr.contains("lektorat"){
            self = .lecture
        } else {
            return nil
        }
    }
    
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
