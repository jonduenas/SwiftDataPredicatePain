//
//  Item.swift
//  SwiftDataPredicatePain
//
//  Created by Jon Duenas on 1/15/24.
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
