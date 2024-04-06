//
//  ApplicationData.swift
//  Book_SwiftData
//
//  Created by David Grau Beltrán  on 14/03/24.
//

//COntrolling the navigation path from an observable object
import SwiftUI
import Observation

@Observable class ApplicationData {
    var viewPath = NavigationPath()
    var selectedBook: Book? = nil
    var selectedAuthor: Author? = nil
}
