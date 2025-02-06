//
//  Item.swift
//  LuminaVision_macOS
//
//  Created by 游述宇 on 2025/2/6.
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
