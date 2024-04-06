//
//  AuthorModel.swift
//  Book_SwiftData
//
//  Created by David Grau Beltrán  on 16/03/24.
//

import Foundation
import Foundation
import SwiftData

//Creating a second model to store the authors

@Model
class AuthorModel: Identifiable {
    @Relationship(deleteRule: .nullify) var books: [Book]? = []
    @Attribute(.unique) var id: UUID = UUID()
    var name: String = ""
    //var books: [Book]? = []
    
    init(name: String, books: [Book]) {
        self.name = name
        self.books = books
    }
}
