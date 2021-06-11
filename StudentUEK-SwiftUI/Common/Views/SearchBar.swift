//
//  SearchBar.swift
//  StudentUEK-SwiftUI
//
//  Created by private on 11/06/2021.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.secondary)
            TextField("Search", text: $searchText)
            Button(action: { self.searchText = "" }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
                    .opacity(searchText.isEmpty ? 0 : 1)
            }
        }.padding(.horizontal)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant("random search text"))
    }
}
