//
//  ScheduleSectionView.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import SwiftUI

struct ScheduleSectionView: View {
    @State var isExpanded: Bool = true
    let section: ScheduleSection
    
    var body: some View {
        VStack {
            HStack {
                Text(section.title)
                Spacer()
                Button(action: toggleExpand) {
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 0 : -90))
                        .foregroundColor(.pink)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            if isExpanded {
                ForEach(section.subjects) { subject in
                    NavigationLink(destination: EmptyView()) { // TODO
                        SubjectCell(subject: subject)
                    }
                }
            }
        }
    }
    
    func toggleExpand() {
        withAnimation {
            isExpanded.toggle()
        }
    }
}
struct ScheduleSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSectionView(section: .init(title: "21023131", subjects: [Mocks.subject]))
    }
}
