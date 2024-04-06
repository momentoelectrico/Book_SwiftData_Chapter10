//
//  ListAuthors.swift
//  Book_SwiftData
//
//  Created by David Grau Beltrán  on 15/03/24.
//

import SwiftUI
import SwiftData

struct ListAuthors: View {
    @Environment(ApplicationData.self) private var appData
    @Query private var authorList: [Author]
    @State private var selection: Author.ID? = nil
    
    var body: some View {
        List(authorList, selection:  $selection) { author in
            Text(author.name)
        }
        .onChange(of: selection, initial: false) { old, idAuthor in
            appData.selectedAuthor = authorList.first(where: { $0.id == idAuthor })
            appData.viewPath.removeLast()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(value: "Add Author", label: {
                    Image(systemName: "plus")
                })
            }
        }
    }
}

#Preview {
    NavigationStack {
        ListAuthors()
            .environment(ApplicationData())
            .modelContainer(for: [Book.self, Author.self], inMemory: true)
    }
}
