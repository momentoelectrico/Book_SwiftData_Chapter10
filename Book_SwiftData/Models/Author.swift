//
//  Author.swift
//  Book_SwiftData
//
//  Created by David Grau Beltrán  on 14/03/24.
//

import Foundation
import SwiftData

//Creating a second model to store the authors

@Model
class Author: Identifiable {
    
    @Relationship(deleteRule: .nullify) var books: [Book]? = []
    @Attribute(.unique) var id: UUID = UUID()
    var name: String = ""
    //var books: [Book]? = []
    
    init(name: String, books: [Book]) {
        self.name = name
        self.books = books
        
    }
 
      
}
   

//In this example, we have turned the author property into an optional property of type Author to store an instance
//of the Author class, the system can see what author object is associated with each book, and which Book objects are associated with each author. The connection between the Book and Authhor class we just created is called a Relationship 
