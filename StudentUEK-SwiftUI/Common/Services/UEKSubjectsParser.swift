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
    private var currentSubject: Subject?
    private var subjects: [Subject] = []
    private var currentContent = ""
    private var response: ((Result<[Subject], Error>) -> Void)?
    
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
                currentSubject?.sourceType = source
            }
            // moodle id for teachers
            if let id = attributeDict["idcel"]?.dropFirst(), currentSubject?.moodleLink == nil {
                currentSubject?.moodleLink = "https://e-uczelnia.uek.krakow.pl/course/view.php?id=\(id)"
            }
        }
        if elementName == Keys.teacher.rawValue, let id = attributeDict[Keys.moodle.rawValue]?.dropFirst() {
            currentSubject?.moodleLink = "https://e-uczelnia.uek.krakow.pl/course/view.php?id=\(id)"
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let key = Keys(rawValue: elementName) else {
            return
        }
        switch key {
        case .date:
            if let subject = currentSubject {
                subjects.append(subject)
            }
            currentSubject = Subject()
            currentSubject?.dateString = currentContent
        case .startTime:
            currentSubject?.startTimeString = currentContent
        case .endTime:
            if let endTimeString = currentContent.split(separator: " ").first {
                currentSubject?.endTimeString = String(endTimeString)
            } else {
                currentSubject?.endTimeString = currentContent
            }
        case .teacher:
            currentSubject?.teacher = currentContent
        case .group:
            currentSubject?.teacher = currentContent
        case .place:
            currentSubject?.place = currentContent
        case .subject:
            currentSubject?.name = currentContent
        case .type:
            currentSubject?.typeString = currentContent
        case .note:
            currentSubject?.note = currentContent
        default:
            print("UNKNOWN KEY: \(elementName)")
        }
        currentContent = ""
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        subjects = []
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        subjects = subjects.map {
            var subject = $0
            if let date = subject.dateString {
                subject = createDatesFor(subject: $0, date: date)
            }
            return subject
        }
        response?(.success(subjects))
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentContent += string
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
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

