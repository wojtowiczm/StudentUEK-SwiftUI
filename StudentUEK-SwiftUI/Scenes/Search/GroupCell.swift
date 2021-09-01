//
//  GroupCell.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 17/06/2021.
//

import SwiftUI

struct GroupCell: View {
    @Environment(\.colorScheme) var colorScheme
    let group: Group
    
    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(10)
                .opacity(0.3)
            NavigationLink(destination: ScheduleView(viewModel: .init(scheduleLoader: ScheduleStoreMock(), grouper: ScheduleGrouper()))) {
                HStack {
                    Text(group.name)
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .padding()
            }
        }
        .accentColor(colorScheme == .dark ? .white : .black)
        .padding(.horizontal)
    }
}

struct GroupCell_Previews: PreviewProvider {
    static var previews: some View {
        GroupCell(group: Mocks.group)
    }
}

