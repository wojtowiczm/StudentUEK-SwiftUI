//
//  Group.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 17/06/2021.
//

import Foundation

struct Group: Identifiable {
    private static let duration = 2
    
    let name: String
    let id: String
    let type: String?
    
    var link: String? {
        return "http://planzajec.uek.krakow.pl/index.php?typ=\(type ?? "G")&id=\(id)&okres=\(Self.duration)&xml"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
