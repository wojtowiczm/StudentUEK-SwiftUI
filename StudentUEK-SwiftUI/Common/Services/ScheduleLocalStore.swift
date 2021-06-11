//
//  ScheduleLocalStore.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import Combine

protocol ScheduleLocalStore {
    func fetchStoredSchedule() -> AnyPublisher<[Subject], Never>
}

final class ScheduleStoreMock: ScheduleLocalStore {
    func fetchStoredSchedule() -> AnyPublisher<[Subject], Never> {
        Future { promise in
            let mocked = Array(0...20).map { _ in Mocks.subject }
            promise(.success(mocked))
        }
        .eraseToAnyPublisher()
    }
}
