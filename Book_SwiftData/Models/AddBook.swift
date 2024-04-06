//
//  AddBook.swift
//  Book_SwiftData
//
//  Created by David Grau Beltrán  on 14/03/24.
//

import SwiftUI
import SwiftData

struct AddBook: View {
    @Environment(ApplicationData.self) private var appData
    @Environment(\.modelContext) var dbContext
    @State private var titleInput: String = ""
    //@State private var authorInput: String = ""
    @State private var yearInput: String = ""
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            TextField("Insert Title", text: $titleInput)
                .textFieldStyle(.roundedBorder)
            /*TextField("Inser Author", text: $authorInput)
                .textFieldStyle(.roundedBorder)*/
            TextField("Inser Year", text: $yearInput)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
            VStack(alignment: .leading) {
                Text("Author")
                NavigationLink(value: "List Authors", label: {
                    Text(appData.selectedAuthor?.name ?? "Select")
                })
            }
            HStack {
                Spacer()
                Button("Save") {
                    storeBook()
                }.buttonStyle(.borderedProminent)
            }
            Spacer()
            /*Button("Save") {
                storeBook()
            }.buttonStyle(.borderedProminent)
            Spacer()*/
        }.padding()
    }
    func storeBook() {
        let title = titleInput.trimmingCharacters(in: .whitespaces)
        //let author = authorInput.trimmingCharacters(in: .whitespaces)
        if let year = Int(yearInput), !title.isEmpty {
            let newBook = Book(title: title, author: appData.selectedAuthor, cover: "nocover", year: year)
            dbContext.insert(newBook)
            appData.selectedAuthor = nil
            appData.viewPath.removeLast()
        }
    }
}

#Preview {
    AddBook()
        .environment(ApplicationData())
        .modelContainer(for: [Book.self], inMemory: true)
}

/*
 This view contains three TextField views to allow the user to enter the title, author, and the year the book was published. Bellow the text fileds there is also a button to store the book. For this purpose, the Button View calls a method that we use to trim the values, check that they are valid, and them to the database
 To save the data in the database, we need to create an instance of the class we are using as a model(in pur case, this
 is the Book class), and then insert it into the context using the insert() method. The object is inserted into the conext and then automatically stored in the database by the container. And becuase the @Query macro keepd the views in sync, the list of books is updated with the new entry, The result is shown below
 */

