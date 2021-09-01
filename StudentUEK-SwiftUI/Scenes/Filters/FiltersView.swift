//
//  FiltersView.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 12/06/2021.
//

import SwiftUI

struct FiltersView: View {
    @Binding var showFilters: Bool
    @Binding var filters: Set<SubjectType>
    
    @State var dragOffset: CGFloat = .zero
    
    var header: some View {
        HStack(alignment: .top) {
            Button("Wyczyść") {
                withAnimation {
                    showFilters.toggle()
                    filters = Set(SubjectType.allCases)
                }
            }
            Spacer()
                RoundedRectangle(cornerRadius: 1).fill(Color.gray)
                    .frame(width: 30, height: 3)
            Spacer()
            Button(action: { withAnimation { showFilters.toggle() }}) {
                Text("Gotowe")
                    .bold()
            }
        }
        .padding(.horizontal)
    }

    var content: some View {
        ForEach(SubjectType.allCases) { type in
            Button(action: { withAnimation { toggle(type: type) } }) {
                HStack {
                    Text(type.localized)
                        .foregroundColor(.black)
                    Spacer()
                    if !isSelected(type: type) {
                        Image(systemName: "checkmark")
                    }
                }
            }
            .padding()
        }
    }
    
    var footer: some View {
        Text("Odznaczenie spowoduje odfiltrowanie")
            .font(.footnote)
            .fontWeight(.light)
    }
    
 
    var body: some View {
        ZStack {
            Color.white
                .cornerRadius(20)
                .ignoresSafeArea()
            VStack {
                header
                content
                footer
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: 400)
        .offset(y: dragOffset)
        .gesture(
            DragGesture()
                .onChanged {
                    if $0.translation.height >= 0 {
                        dragOffset = $0.translation.height
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        if dragOffset > 100 {
                            showFilters = false
                        }
                        dragOffset = .zero
                    }
                }
        )
    }
    
    func isSelected(type: SubjectType) -> Bool {
        !filters.contains(type)
    }

    func toggle(type: SubjectType) {
        if filters.contains(type) {
            filters.remove(type)
        } else {
            filters.insert(type)
        }
    }
    
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView(showFilters: .constant(true), filters: .constant([]))
    }
}
