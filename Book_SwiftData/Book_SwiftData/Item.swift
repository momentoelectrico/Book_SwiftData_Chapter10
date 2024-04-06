//
//  Item.swift
//  Book_SwiftData
//
//  Created by David Grau Beltrán  on 13/03/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
