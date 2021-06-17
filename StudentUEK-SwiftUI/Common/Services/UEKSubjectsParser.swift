//
//  UEKSubjectsParser.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 18/06/2021.
//

import Foundation
import Combine

protocol SubjectsParsingLogic {
    func parse(data: Data) -> AnyPublisher<[Subject], Error>
}

final class UEKSubjectsService: NSObject, SubjectsParsingLogic {
    enum Keys: String {
        case date = "termin"
        case dayKey = "dzien"
        case startTime = "od-godz"
        case endTime = "do-godz"
        case teacher = "nauczyciel"
        case place = "sala"
        case subject = "przedmiot"
        case type = "typ"
        case note = "uwagi"
        case group = "grupa"
        case schedule = "plan-zajec"
        case moodle
    }
    var subjects: [Subject] = []
    var currentContent = ""
    var sourceType: String?
    var teacherMoodleLink: String?
    var response: ((Result<[Subject], Error>) -> Void)?
    
    func parse(data: Data) -> AnyPublisher<[Subject], Error> {
        Future { [weak self] promise in
            let parser = XMLParser(data: data.utf8Convertible())
            parser.delegate = self
            self?.response = promise
            parser.parse()
        }
        .eraseToAnyPublisher()
    }
}

extension Data {
    func utf8Convertible() -> Data {
        guard String(data: self, encoding: .utf8) == nil else { return self }
        // NOTE: 160 is not UTF-8 compatibile space -> replace with standard space (32)
        return Data(self.map { $0 == 160 ? 32 : $0 })
    }
}

extension UEKSubjectsService: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == Keys.schedule.rawValue {
            if let source = attributeDict[Keys.type.rawValue] {
                sourceType = source
            }
            // moodle id for teachers
            if let id = attributeDict["idcel"]?.dropFirst() {
                teacherMoodleLink = "https://e-uczelnia.uek.krakow.pl/course/view.php?id=\(id)"
            }
        }
        if elementName == Keys.teacher.rawValue, let id = attributeDict[Keys.moodle.rawValue]?.dropFirst() {
            subjects[subjects.count - 1].moodleLink = "https://e-uczelnia.uek.krakow.pl/course/view.php?id=\(id)"
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let key = Keys(rawValue: elementName) else {
            return
        }
        switch key {
        case .date:
            subjects.append(Subject())
            subjects[subjects.count - 1].dateString = currentContent
        case .startTime:
            subjects[subjects.count - 1].startTimeString = currentContent
        case .endTime:
            if let endTimeString = currentContent.split(separator: " ").first {
                subjects[subjects.count - 1].endTimeString = String(endTimeString)
            } else {
                subjects[subjects.count - 1].endTimeString = currentContent
            }
            
        case .teacher:
            subjects[subjects.count - 1].teacher = currentContent
        case .group:
            subjects[subjects.count - 1].teacher = currentContent
        case .place:
            subjects[subjects.count - 1].place = currentContent
        case .subject:
            subjects[subjects.count - 1].name = currentContent
        case .type:
            subjects[subjects.count - 1].type = SubjectType(rawValue: currentContent)
        case .note:
            subjects[subjects.count - 1].note = currentContent
            break
        default:
            print("UNKNOWN KEY: \(elementName)")
        }
        currentContent = ""
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        teacherMoodleLink = nil
        sourceType = nil
        subjects = []
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        subjects = subjects.map {
            var subject = $0
            if let date = subject.dateString {
                subject = createDatesFor(subject: $0, date: date)
            }
            if let moodleLink = teacherMoodleLink,
                subject.moodleLink == nil {
                subject.moodleLink = moodleLink
            }
            subject.sourceType = sourceType
            return subject
        }
        response?(.success(subjects))
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentContent += string
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print(parseError.localizedDescription)
    }
    
    func createDatesFor(subject: Subject, date: String) -> Subject {
        var newSubject = subject
        if let sTime = subject.startTimeString,
            let preparedDate = Date
                .createDateFromStrings(time: sTime, date: date) {
            newSubject.startTime = preparedDate
            newSubject.dayName = preparedDate.formatted(to: .day)
        }
        if let eTime = subject.endTimeString {
            newSubject.endTime = Date.createDateFromStrings(time: eTime, date: date)
        }
        return newSubject
    }
}

