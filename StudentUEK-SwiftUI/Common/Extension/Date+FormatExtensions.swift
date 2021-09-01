//
//  Date+FormatExtensions.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import Foundation

enum DateFormat: String {
    case time = "H:mm"
    case date = "yyyy-MM-dd"
    case dateAndTime = "yyyy-MM-dd H:mm"
    case day = "EEEE"
    case pigeon = "yyyy-MM-dd hh:mm:ss"
}

extension Date {

    static func createDate(from date: Date, time: Date) -> Date? {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        var finalComponets = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        finalComponets.year = dateComponents.year
        finalComponets.month = dateComponents.month
        finalComponets.day = dateComponents.day
        finalComponets.hour = timeComponents.hour
        finalComponets.minute = timeComponents.minute
        return Calendar.current.date(from: finalComponets)
    }
    
    static func createDateFromStrings(time: String, date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "CET")
        dateFormatter.locale = Locale.init(identifier: "pl")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let finalDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "H:mm"
            if let finalTime = dateFormatter.date(from: time) {
                return createDate(from: finalDate, time: finalTime)
            }
        }
        return nil
    }
    
    func withWeek(offset: Int) -> Date? {
        return Calendar.current.date(byAdding: .weekOfYear, value: offset, to: self)
    }

    func formatted(to format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "CET")
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    
    func isLongerThanThreeDays(comparedTo currentDate: Date) -> Bool {
        return Calendar.current.dateComponents([.day], from: self, to: currentDate).day ?? 0 > 3
    }
}
