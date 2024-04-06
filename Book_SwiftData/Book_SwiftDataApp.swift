//
//  Book_SwiftDataApp.swift
//  Book_SwiftData
//
//  Created by David Grau Beltrán  on 13/03/24.
//

import SwiftUI
import SwiftData

@main
struct Book_SwiftDataApp: App {
    @State private var appData = ApplicationData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appData)
                .modelContainer(for: [Book.self, Author.self])
        }
    }
}

/*
@main
struct Book_SwiftDataApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
*/
