//
//  Portfolio.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/6/24.
//

import Foundation

class PortfolioModel {
    struct Portfolio: Identifiable {
        let id: UUID = UUID()
        var stockSymbol: String
        var quantity: Int
        var cost: Double
        
        
        var totalCost: Double {
            return Double(quantity) * cost
        }
    }
}
