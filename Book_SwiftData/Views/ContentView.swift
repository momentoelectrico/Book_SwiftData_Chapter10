//
//  ContentView.swift
//  Book_SwiftData
//
//  Created by David Grau Beltrán  on 13/03/24.
//

import SwiftUI
import SwiftData

//Fetching books from the database
struct ContentView: View {
    @Environment(ApplicationData.self) private var appData
    @Environment(\.modelContext) var dbContext
    // -- Static Query --
    //Sorting Objects: Objects returned by query are usually in the orde in which they were created, but this in not guaranteed. To specify a particulat order, the @Query macro can take two arguments. the sort argument is the key path to the property we want to use to sort the objects, and the order argument determines whether the objects are listed in ascending or descending order(forward or reverse)
    //@Query(sort: \Book.title, order: .forward) private var listBooks: [Book] //Sorting objects
    //@Query var listBooks: [Book] // --> First @Query
    //@Query(sort: [SortDescriptor(\Book.title, order: .reverse)]) private var listBooks: [Book] //Sorting objects with a SortDescriptoir strucure
    //@Query(sort: [SortDescriptor(\Book.author?.name, order: .forward), SortDescriptor(\Book.year)]) private var listBooks: [Book] //Sorting books by author and year, the advantage of using SortDescriptor strucures is that we can sprecify multiple conditions for sorting the list,l the finalk order is determinades based on the position of the SortDercription structures in the array
    //@Query(sort: [SortDescriptor(\Book.title, comparator: .lexical, order: .forward)]) private var listBooks: [Book]//Sroting with a lexical comparator, By default, the values are stored with the localizedStandard structure.
    //@Query(filter: #Predicate<Book> { $0.year == 2021 }) private var listBooks: [Book] //Filtering books by year- #Predicate(Closure)-This macro produces the code to create a predicate. The argument is a closure that specifies the condition to filter the objects.
    //@Query(filter: #Predicate<Book> { $0.author?.name.localizedStandardContains("Miguel de Cervantes") == true}) private var listBooks: [Book] //Filtering books by author
    // -- Dinamic Query --
    //@State private var orderBooks: SortOrder = .forward //Listing 10-29: Defining a dynamic query
    @State private var searchValue: String = "" //Listing 10-30: Searching books by title
    
    
    var body: some View {
        NavigationStack(path: Bindable(appData).viewPath) {
            //ListBooksView(orderBooks: orderBooks)
            ListBooksView(search: searchValue)
                .listStyle(.plain)
                .navigationTitle("Books")
                .toolbarTitleDisplayMode(.inline)
                .toolbar {
                    /*
                     ToolbarItem(placement: .navigationBarTrailing){ //Listing 10-29
                     Button(action: {
                     orderBooks = orderBooks == .forward ? .reverse : .forward
                     }, label: {
                     Image(systemName: "gear")
                     })
                     }*/
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(value: "Add Book", label: {
                            Image(systemName: "plus")
                        })
                    }
                }
                .navigationDestination(for: String.self, destination: { viewID in
                    
                    if viewID == "Add Book" {
                        AddBook()
                    } else if viewID == "List Authors" {
                        ListAuthors()
                    } else if viewID == "Add Author" {
                        AddAuthor()
                    }
                })
                .onAppear {
                    let predicate = #Predicate<Book> { book in
                        book.author?.name == nil
                    }
                    let sort = SortDescriptor<Book>(\.title, order: .forward)
                    let descriptor = FetchDescriptor<Book>(predicate: predicate, sortBy: [sort])
                    
                    if let count = try? dbContext.fetchCount(descriptor) {
                        print(count)
                    }
                }
            /*
                .onAppear {
                    let predicate = #Predicate<Book> { book in
                        book.author?.name == nil
                    }
                    let sort = SortDescriptor<Book>(\.title, order: .forward)
                    
                    let descriptor = FetchDescriptor<Book>(predicate: predicate, sortBy:
                                                            [sort])
                    if let list = try? dbContext.fetch(descriptor) {
                        for book in list {
                            print(book.title)
                        }
                    }
                    
                }
            */
                .searchable(text: $searchValue, prompt: Text("Search"))
            
        }
        
    }
}
    



//Actual Structure
struct ListBooksView: View {
    @Query private var listBooks: [Book]
    
    init(search: String) {
        var predicate = #Predicate<Book> { _ in true }
        if !search.isEmpty {
            let searching = search.lowercased()
            predicate = #Predicate<Book> { book in
                book.title.localizedStandardContains(searching)
            }
        }
        _listBooks = Query<Book, [Book]>(filter: predicate, sort: \Book.title, order: .forward)
        
    }
    var body: some View {
        List {
            ForEach(listBooks) { book in
                CellBook(book: book)
            }
        }
    }
    
}
/*
struct ListBooksView: View {
    @Query var listBooks: [Book]
    
    init(orderBooks: SortOrder) {
        _listBooks = Query(sort: \Book.title, order: orderBooks)
    }
    
    var body: some View {
        List {
            ForEach(listBooks) { book in
                CellBook(book: book)
            }
        }
    }
}
*/
struct CellBook: View {
    let book: Book
    
    var body: some View{
        HStack(alignment: .top) {
            Image(book.cover)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 100)
            VStack(alignment: .leading, spacing: 2) {
                Text(book.title).bold()
                Text(book.author?.name ?? "Undefined")
                Text(book.displayYear).font(.caption)
                Spacer()
            }
            Spacer()
        }.padding([.top], 10)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(ApplicationData())
            .modelContainer(PreviewContainer.container)
    }
}
/*
#Preview {
        ContentView()
            .environment(ApplicationData())
        // .modelContainer(for: [Book.self], inMemory: true)
            .modelContainer(PreviewContainer.container)
    
}
 */

/*
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
*/


/* 
 // Order de books
 var body: some View {
     NavigationStack(path: Bindable(appData).viewPath) {
         ListBooksView(orderBooks: orderBooks)
         /*List(listBooks) {
             book in CellBook(book: book)
         }*/
         
         /*List { //Static Query
             ForEach(listBooks) { book in
                 CellBook(book: book)
             }
             .onDelete { indexes in
                 for index in indexes {
                     dbContext.delete(listBooks[index])
                 }
             }
         }*/
         .listStyle(.plain)
         .navigationTitle("Books")
         .toolbarTitleDisplayMode(.inline)
         .toolbar {
             ToolbarItem(placement: .navigationBarTrailing) {
                 Button(action: {
                     orderBooks = orderBooks == .forward ? .reverse : .forward
                 }, label: {
                     Image(systemName: "gear")
                 })
                 NavigationLink(value: "Add Book", label: {
                     Image(systemName: "plus")
                 })
             }
             ToolbarItem(placement: .navigationBarTrailing) {
                 NavigationLink(value: "Add Book", label: {
                     Image(systemName: "plus")
                 })
             }
         }
 */
