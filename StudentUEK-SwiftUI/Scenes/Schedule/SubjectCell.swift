//
//  SubjectCell.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import SwiftUI

struct SubjectCell: View {
    @Environment(\.colorScheme) var colorScheme
    let subject: Subject
    
    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(10)
                .opacity(0.2)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(subject.name ?? "")
                        .fixedSize(horizontal: false, vertical: true)
                        .minimumScaleFactor(0.7)
                        .lineLimit(4)
                        .font(Font.system(size: 24).bold())
                    
                    Spacer()
                    VStack {
                        Text(subject.timeString)
                            .font(.system(size: 20))
                        Spacer()
                    }
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text(subject.type ?? "")
                        Text(subject.teacher ?? "")
                    }
                    Spacer()
                    switch subject.formattedPlace! {
                    case .online(let url):
                        Button(action: { openOnlineLesson(url) }) {
                            Text("Dołącz")
                                .padding()
                                .background(Color(UIColor.systemTeal))
                                .cornerRadius(20)
                                .shadow(radius: 5)
                        }
                    case .offline(let place):
                        Text(place)
                    }
                }
                Text(subject.note ?? "")
                    .foregroundColor(Color.red)
            }
            .accentColor(colorScheme == .dark ? .white : .black)
            .padding()
        }
        .padding(.horizontal)
    }
    
    func openOnlineLesson(_ url: URL) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}


struct SubjectCell_Previews: PreviewProvider {
    static var previews: some View {
        SubjectCell(subject: Mocks.subject)
    }
}
