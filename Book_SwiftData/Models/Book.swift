//
//  Book.swift
//  Book_SwiftData
//
//  Created by David Grau Beltrán  on 13/03/24.
//

import Foundation
import SwiftData

@Model
class Book: Identifiable {
    @Relationship(deleteRule: .nullify, inverse: \Author.books) var author: Author?
    @Attribute(.unique) var id: UUID = UUID() //The UUID structure guarantees that each value is unique
    var title: String = ""
    //var author: Author? //Creating a relationship with the Author instance
    var cover: String = ""
    var year: Int = 0
    
    init(title: String, author: Author?, cover: String, year: Int) { //id: UUID
        //self.id = id
        self.title = title
        self.author = author
        self.cover = cover
        self.year = year
    }
    var displayYear: String {
        get {
            let value = year > 0 ? String(year) : "Undefined"
            return value
        }
    }
}

