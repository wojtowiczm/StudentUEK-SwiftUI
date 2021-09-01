//
//  UEKGroupsParser.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 18/06/2021.
//

import Foundation
import Combine

protocol GroupsParsingLogic {
    func parse(data: Data) -> AnyPublisher<[Group], Error>
}

final class UEKGroupsParser: NSObject, GroupsParsingLogic {
    enum XMLKeys: String {
        case id
        case name = "nazwa"
        case type = "typ"
        case content = "zasob"
    }
    
    private var groups: [Group] = []
    private var currentGroup: Group?
    
    private var response: ((Result<[Group], Error>) -> Void)?
    
    func parse(data: Data) -> AnyPublisher<[Group], Error> {
        Future { [weak self] promise in
            let parser = XMLParser(data: data)
            parser.delegate = self
            self?.response = promise
            parser.parse()
        }
        .eraseToAnyPublisher()
    }
}

extension UEKGroupsParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        guard elementName == XMLKeys.content.rawValue, let name = attributeDict[XMLKeys.name.rawValue] else { return }
        currentGroup = Group(
            name: name,
            id: attributeDict[XMLKeys.id.rawValue] ?? UUID().uuidString,
            type: attributeDict[XMLKeys.type.rawValue])
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if let group = currentGroup {
            groups.append(group)
        }
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        groups.removeAll()
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        response?(.success(groups))
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
    }
}
