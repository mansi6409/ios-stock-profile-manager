//
//  History.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/7/24.
//

import Foundation

struct Result: Codable {
    let v: Int
    let vw: Double
    let o: Double
    let c: Double
    let h: Double
    let l: Double
    let t: Int64
    let n: Int
}

class History: Codable {
    let ticker: String
    let queryCount: Int
    let resultsCount: Int
    let adjusted: Bool
    let results: [Result]
    
    init(ticker: String, queryCount: Int, resultsCount: Int, adjusted: Bool, results: [Result]) {
        self.ticker = ticker
        self.queryCount = queryCount
        self.resultsCount = resultsCount
        self.adjusted = adjusted
        self.results = results
    }
}
