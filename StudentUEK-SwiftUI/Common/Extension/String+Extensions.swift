//
//  String+Extensions.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 12/06/2021.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
}
