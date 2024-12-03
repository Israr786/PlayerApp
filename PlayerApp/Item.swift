//
//  Item.swift
//  PlayerApp
//
//  Created by Israrul on 11/26/24.
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
