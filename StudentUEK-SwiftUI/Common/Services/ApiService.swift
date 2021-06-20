//
//  ApiService.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 18/06/2021.
//

import Foundation
import Combine

final class ApiService<Response> {
    let groupParser: GroupsParsingLogic
    let subjectsParser: SubjectsParsingLogic
    let session: URLSession

    init(
        groupParser: GroupsParsingLogic = UEKGroupsParser(),
        subjectsParser: SubjectsParsingLogic = UEKSubjectsService(),
        session: URLSession = .shared) {
        self.groupParser = groupParser
        self.subjectsParser = subjectsParser
        self.session = session
    }
    
    func loadData(for url: URL) -> AnyPublisher<Data, Error> {
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

extension ApiService where Response == [Group] {
    func loadAllGroups() -> AnyPublisher<[Group], Error> {
        let groupsUrl = URL(string: "http://planzajec.uek.krakow.pl/index.php?typ=G&xml")!
        let teachersUrl = URL(string: "http://planzajec.uek.krakow.pl/index.php?typ=N&xml")!
        let placesUrl = URL(string: "http://planzajec.uek.krakow.pl/index.php?typ=S&xml")!

        return Publishers.CombineLatest3(
            loadGroups(for: groupsUrl),
            loadGroups(for: teachersUrl),
            loadGroups(for: placesUrl)
        )
        .map { groups, teachers, places in
            print(groups.count, teachers.count, places.count)
            return groups + teachers + places
        }
        .eraseToAnyPublisher()
    }
    
    func loadGroups(for url: URL) -> AnyPublisher<[Group], Error> {
        loadData(for: url)
            .flatMap { data in
                self.groupParser.parse(data: data)
            }
            .eraseToAnyPublisher()
    }
}

extension ApiService where Response == [Subject] {
    func loadSchedule(for url: URL) -> AnyPublisher<[Subject], Error> {
        loadData(for: url)
            .flatMap { data in
                self.subjectsParser.parse(data: data)
            }
            .eraseToAnyPublisher()
    }
}
