//
//  StockPriceDetails.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/7/24.
//

import Foundation
import SwiftUI

class StockPriceDetails: Decodable, Identifiable {
    var id: UUID = UUID()  // Note: ensure your JSON actually contains a UUID if you're using this in a real app, or generate it as a placeholder
    var c: Double?
    var d: Double?
    var dp: Double?
    var h: Double?
    var l: Double?
    var o: Double?
    var pc: Double?
    var t: Double?
    
    enum CodingKeys: String, CodingKey {
        case c = "c"
        case d = "d"
        case dp = "dp"
        case h = "h"
        case l = "l"
        case o = "o"
        case pc = "pc"/* = "estimated_currency" */ // Example of mapping a JSON key to a different property dp
        case t = "t"
            // Add other mappings as necessary
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        c = try container.decodeIfPresent(Double.self, forKey: .c)
        d = try container.decodeIfPresent(Double.self, forKey: .d)
        dp = try container.decodeIfPresent(Double.self, forKey: .dp)
        h = try container.decodeIfPresent(Double.self, forKey: .h)
        l = try container.decodeIfPresent(Double.self, forKey: .l)
        o = try container.decodeIfPresent(Double.self, forKey: .o)
        pc = try container.decodeIfPresent(Double.self, forKey: .pc)
        t = try container.decodeIfPresent(Double.self, forKey: .t)
    }
    
    init() {
        self.id = UUID()  // Generate a new UUID
        self.c = 0.0
        self.d = 0.0
        self.dp = 0.0
        self.h = 0.0
        self.l = 0.0
        self.o = 0.0
        self.pc = 0.0
        self.t = 0.0
    }

}
