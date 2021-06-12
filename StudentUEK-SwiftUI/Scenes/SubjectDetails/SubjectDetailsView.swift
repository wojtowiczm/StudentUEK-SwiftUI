//
//  SubjectDetailsView.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 12/06/2021.
//

import SwiftUI

struct SubjectDetailsView: View {
    let subject: Subject
    var body: some View {
        Text("Hello, World!")
    }
}

struct SubjectDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectDetailsView(subject: Mocks.subject)
    }
}
