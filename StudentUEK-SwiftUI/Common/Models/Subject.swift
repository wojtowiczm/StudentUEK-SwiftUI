//
//  Subject.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import Foundation

enum SubjectType: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
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

struct Subject: Identifiable {
    var id = UUID()
    
    enum PlaceType {
        case online(url: URL)
        case offline(place: String)
    }
    var dateString: String?
    var dayName: String?
    var startTime: Date?
    var startTimeString: String?
    var endTime: Date?
    var endTimeString: String?
    var name: String?
    var teacher: String?
    var place: String?
    var type: SubjectType?
    var note: String?
    var moodleLink: String?
    var sourceType: String?
    var userNote: SubjectNote?
    var isHiddenBySearch = false
    var isHiddenByFilter = false
    var isHiddenByMarker = false
    
    var formattedPlace: PlaceType? {
//        guard let place = place else { return nil }
//        if let url = createLink(input: place) {
//            return .online(url: url)
//        }
//        return .offline(place: place)
        .online(url: URL(string: "https://stackoverflow.com/questions/52983673/uiapplication-shared-open-url-url-etc-doesnt-open-anything")!)
    }
    
    var timeString: String {
        "\(startTimeString ?? "")-\(endTimeString ?? "")"
    }
    
    func contains(searchText: String) -> Bool {
        return ![name, type?.localized, teacher, dayName]
            .compactMap { $0?.lowercased() }
            .filter { $0.contains(searchText) }
            .isEmpty
    }
    
    private func createLink(input: String) -> URL? {
        guard input.contains("http") else { return nil}
        let link = input.slice(from: "<a href=\"", to: "\">")
        return URL(string: link!)
    }
}
 
struct SubjectNote {
    var content: String?
    var teacher: String?
    var date: Date?
}


extension String {
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
