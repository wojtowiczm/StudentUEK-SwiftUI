//
//  SettingsViewModel.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 12/06/2021.
//

import Combine

final class SettingsViewModel: ObservableObject {
    @Published var nightModeEnabled: Bool = false
    @Published var notificationsEnabled: Bool = false
    @Published var notificationsInterval: Double = 0
    @Published var actionSheet: ActionSheetModel?
    @Published var showReconfigurationProcess = false
    @Published var showReconfigurationProcessForTeachers = false
    
    func showReconfigureAlert() {
        actionSheet = .init(title: nil, message: nil)
    }
    
    func reconfigure() {
        showReconfigurationProcess = true
    }
    
    func reconfigureAsTeacher() {
        showReconfigurationProcessForTeachers = true
    }
}
