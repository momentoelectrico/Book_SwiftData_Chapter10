//
//  ModelContainer.swift
//  Book_SwiftData
//
//  Created by David Grau Beltrán  on 05/04/24.
//

import SwiftUI
import SwiftData

class PreviewContainer {
    @MainActor
    
    static let container: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Book.self, Author.self, configurations: config)
            
            let author = Author(name: "Stephen King", books: [])
            container.mainContext.insert(author)
            
            let book1 = Book(title: "Christine", author: author, cover: String(), year: 1987)
            let book2 = Book(title: "IT", author: author, cover: String(), year: 1986)
            
            container.mainContext.insert(book1)
            container.mainContext.insert(book2)
            
            return container
        } catch {
            fatalError("Failed to create container")
        }
    }()
}
