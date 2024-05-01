    //
    //  MainChartsViewModel.swift
    //  Stock Profile Manager
    //
    //  Created by Mansi Garg on 4/29/24.
    //

import Foundation
import Alamofire
import SwiftUI

struct Earning: Decodable {
    let actual: Double
    let estimate: Double
    let period: String
    let quarter: Int
    let surprise: Double
    let surprisePercent: Double
    let symbol: String
    let year: Int
}

struct Trends: Decodable {
    let buy: Int
    let hold: Int
    let period: String
    let sell: Int
    let strongBuy: Int
    let strongSell: Int
    let symbol: String
}

struct Sentiments: Decodable {
    let symbol: String
    let year: Double
    let month: Double
    let change: Double
    let mspr: Double
}

struct SentimentsResponse: Decodable {
    let data: [Sentiments]
    let symbol: String
}

struct SentimentsAggregate: Decodable {
    var mt: Double = 0
    var mp: Double = 0
    var mn: Double = 0
    var ct: Double = 0
    var cp: Double = 0
    var cn: Double = 0
}

//struct History: Decodable {
//    let v: Double
//    let vw: Double
//    let o: Double
//    let c: Double
//    let h: Double
//    let l: Double
//    let t: Double
//    let n: Double
//
//}

typealias FilteredHistory = [[Double]]

@Observable
class ChartsModel {
    var timehistory: History? = nil
    var filteredtimehistory: FilteredHistory = []
    var history: History? = nil
    var ohlc: FilteredHistory = []
    var vol: FilteredHistory = []
    var trends: [Trends] = []
    var strongbuy: [Int] = []
    var buy: [Int] = []
    var hold: [Int] = []
    var sell: [Int] = []
    var strongsell: [Int] = []
    var dates: [String] = []
    var earning: [Earning] = []
    var datessurprise: [String] = []
    var surprise: [Double] = []
    var actual: [Double] = []
    var estimate: [Double] = []
    var sentiments: [Sentiments] = []
    var sentimentsAggregate = SentimentsAggregate()
    var label: [String] = []
    
    let currentDate = Date()
    
    private let baseUrl = "http://localhost:8000/api"
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func fetchTimeHistoryData(ticker: String, completion: @escaping () -> Void) {
        fetchTimeHistory(ticker: ticker) {
            guard let results = self.timehistory?.results else {
                print("Time history results are nil")
                completion()
                return
            }
            
            self.filteredtimehistory = results.map { result in
                [Double(result.t), result.c]
            }
            completion()
        }
    }
    
    func fetchTimeHistory(ticker: String, completion: @escaping () -> Void) {
        let currentdate = formatDate(currentDate)
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = -2
        let pastdate = formatDate(calendar.date(byAdding: dateComponents, to: Date()) ?? Date())
        AF.request("\(baseUrl)/highchartsHourly?symbol=\(ticker)&fromDate=\(pastdate)&toDate=\(currentdate)").responseDecodable(of: History.self) { response in
            switch response.result {
                case .success(let value):
                    self.timehistory = value
                    completion()
                case .failure(let error):
                    print("Error fetching history: \(error)")
            }
        }
    }
    
    func fetchHistoryData(ticker: String, completion: @escaping () -> Void) {
        fetchHistory(ticker: ticker) {
            guard let results = self.history?.results else {
                print("Time history results are nil")
                completion()
                return
            }
            self.ohlc = results.map { result in
                [Double(result.t), result.o, result.h, result.l, result.c]
            }
            self.vol = results.map { result in
                [Double(result.t), Double(result.v)]
            }
            completion()
        }
    }
    
    func fetchHistory(ticker: String, completion: @escaping () -> Void) {
        let currentdate = formatDate(currentDate)
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = -2
        dateComponents.day = -1
        let pastdate = formatDate(calendar.date(byAdding: dateComponents, to: Date()) ?? Date())
        AF.request("\(baseUrl)/history?symbol=\(ticker)&fromDate=\(pastdate)&toDate=\(currentdate)").responseDecodable(of: History.self) { response in
            switch response.result {
                case .success(let value):
                    self.history = value
                    completion()
                case .failure(let error):
                    print("Error fetching history: \(error)")
            }
        }
    }
    
    func fetchTrends(ticker: String, completion: @escaping () -> Void) {
        AF.request("\(baseUrl)/recommendationTrends?symbol=\(ticker)").responseDecodable(of: [Trends].self) { response in
            switch response.result {
                case .success(let value):
                    self.trends = value
                    self.strongbuy = self.trends.map { result in
                        result.strongBuy
                    }
                    self.buy = self.trends.map { result in
                        result.buy
                    }
                    self.hold = self.trends.map { result in
                        result.hold
                    }
                    self.sell = self.trends.map { result in
                        result.sell
                    }
                    self.strongsell = self.trends.map { result in
                        result.strongSell
                    }
                    self.dates = self.trends.map { result in
                        String(result.period.prefix(7))
                    }
                    completion()
                case .failure(let error):
                    print("Error fetching company peers: \(error)")
            }
        }
    }
    
    func fetchEarnings(ticker: String, completion: @escaping () -> Void) {
        AF.request("\(baseUrl)/earnings?symbol=\(ticker)").responseDecodable(of: [Earning].self) { response in
            switch response.result {
                case .success(let value):
                    self.earning = value
                    self.datessurprise = self.earning.map { result in
                        result.period
                    }
                    self.surprise = self.earning.map { result in
                        result.surprise
                    }
                    self.actual = self.earning.map { result in
                        result.actual
                    }
                    self.estimate = self.earning.map { result in
                        result.estimate
                    }
                    self.label = self.earning.map { (result) in
                        "\(result.period)<br/>Surprise: \(result.surprise)"
                    }
                    completion()
                case .failure(let error):
                    print("Error fetching company peers: \(error)")
            }
        }
    }
    
    func fetchSentiments(symbol: String, completion: @escaping () -> Void){
        AF.request("\(baseUrl)/insiderSentiment?symbol=\(symbol)").responseDecodable(of: SentimentsResponse.self) { response in
            switch response.result {
                case .success(let value):
                    self.sentiments = value.data
                    self.setAggregates(response: self.sentiments)
                    completion()
                    
                case .failure(let error):
                    print("Error in fetching sentiments \(error)")
            }
        }
    }
    
    func setAggregates(response: [Sentiments]) {
        var agg = SentimentsAggregate ()
        
        for item in response {
                // Update total changes
            agg.ct += item.change
            
                // Update mspr aggregate
            agg.mt += item.mspr
            agg.mt = round(agg.mt * 100) / 100  // Round to 2 decimal places
            
            if item.change > 0 {
                agg.cp += item.change
                agg.cp = round(agg.cp * 100) / 100  // Round to 2 decimal places
            } else {
                agg.cn += item.change
                agg.cn = round(agg.cn * 100) / 100  // Round to 2 decimal places
            }
            
            if item.mspr > 0 {
                agg.mp += item.mspr
                agg.mp = round(agg.mp * 100) / 100  // Round to 2 decimal places
            } else {
                agg.mn += item.mspr
                agg.mn = round(agg.mn * 100) / 100  // Round to 2 decimal places
            }
        }
        
        self.sentimentsAggregate = agg
    }
}

