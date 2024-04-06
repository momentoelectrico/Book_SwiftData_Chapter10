//
//  AddAuthor.swift
//  Book_SwiftData
//
//  Created by David Grau Beltrán  on 15/03/24.
//

import SwiftUI
import SwiftData

struct AddAuthor: View {
    @Environment(ApplicationData.self) private var appData
    @Environment(\.modelContext) var dbContext
    @State private var nameInput: String = ""
    @State private var openAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("Insert Name", text: $nameInput)
                .textFieldStyle(.roundedBorder)
            HStack {
                Spacer()
                Button("Save") {
                    storeAuthor()
                }.buttonStyle(.borderedProminent)
            }
            Spacer()
        }.padding()
                .alert("Error", isPresented: $openAlert, actions: {
                    Button("Ok", role: .cancel, action: {})
                }, message: { Text("The author already exists") })
        }
        func storeAuthor() {
            let name = nameInput.trimmingCharacters(in: .whitespaces)
            if !name.isEmpty {
                let predicate = #Predicate<Author> { $0.name == name }
                let descriptor = FetchDescriptor<Author>(predicate: predicate)
                if let count = try? dbContext.fetchCount(descriptor), count > 0 {
                    openAlert = true
                } else{
                let newAuthor = Author(name: name, books: [])
                dbContext.insert(newAuthor)
                appData.selectedAuthor = newAuthor
                appData.viewPath.removeLast(2)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddAuthor()
            .environment(ApplicationData())
            .modelContainer(for: [Book.self, Author.self], inMemory: true)
    }
}
