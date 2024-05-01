    //
    //  portfolio.service.swift
    //  Stock Profile Manager
    //
    //  Created by Mansi Garg on 4/7/24.
    //

import Foundation
import Alamofire
import SwiftyJSON
import Combine

struct PortfolioRecord:  Decodable, Identifiable {
    let id = UUID()
    var stocksymbol: String
    var quantity: Double
    var cost: Double
    var totalValue: Double?
    var change: Double?
    var changePercentage: Double?
    var companyName: String?
}

struct WalletMoney:  Decodable, Identifiable {
    let id = UUID()
    var key: String
    var walletmoney: Double
}

    //struct WalletResponse: Decodable {
    //    let wallet: [WalletMoney]
    //}

class PortfolioService: ObservableObject {
    private let baseUrl = "http://localhost:8000/api"
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var walletMoney: Double = 25000
    @Published private(set) var portfolioRecordsData: [PortfolioRecord] = []
    @Published private(set) var netWorth: Double = 25000
    var tempWorth: Double = 0
    
        //    @Published private(set) var portfolioRecords: [PortfolioRecord] = []
    
    @Published var stockPriceDetails: StockPriceDetails?
    @Published var companyInfo: Details?
    
    init() {
        fetchWalletMoney()
        getPortfolioRecordsData()
    }
    
    func fetchWalletMoney() {
        let url = "\(baseUrl)/getwalletmoney"
            //        print("fetchWalletMoney url: \(url)")
        AF.request(url).validate().responseDecodable(of: [WalletMoney].self) { [weak self] response in
                //            print("fetchWalletMoney response: \(response)")
            switch response.result {
                case .success(let value):
                    if let firstWallet = value.first {
                        DispatchQueue.main.async {
                            self?.walletMoney = firstWallet.walletmoney
                        }
                    }
                case .failure(let error):
                    print("fetchwalletmoney error - \(error)")
            }
        }
    }
    
    func updateWalletMoney(amount: Double) {
        var updatedAmount = (walletMoney + amount).rounded(toPlaces: 2)
        let url = "\(baseUrl)/setwalletmoney?updatedAmount=\(updatedAmount)"
        
        AF.request(url).validate().responseDecodable(of: [WalletMoney].self)  { response in
            switch response.result {
                case .success(let value):
                    if let firstWallet = value.first {
                        DispatchQueue.main.async {
                            self.walletMoney = firstWallet.walletmoney
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func updatePortfolioRecord(symbol: String, quantity: Double, price: Double) {
        let url = "\(baseUrl)/updateportfoliorecord?symbol=\(symbol)&stockquantity=\(quantity)&price=\(price)"
        AF.request(url).validate().responseDecodable(of: [PortfolioRecord].self){ response in
            switch response.result {
                case .success(let value):
                    var updatedRecords: [PortfolioRecord] = []
                    
                    let dispatchGroup = DispatchGroup()
                    
                    value.forEach { record in
                        dispatchGroup.enter()
                        
                        self.fetchDetailsForPortfolioRecords(record) { updatedRecord in
                                // Update the record with the new data
                            updatedRecords.append(updatedRecord)
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                            // Update the entire array and notify observers
                        self.portfolioRecordsData = updatedRecords
                    }
                case .failure(let error):
                    print("add to portfolio \(error)")
            }
        }
    }
    
    func addPortfolioRecord(symbol: String, quantity: Double, price: Double) {
        let url = "\(baseUrl)/addportfoliorecord?symbol=\(symbol)&stockquantity=\(quantity)&price=\(price)"
        AF.request(url).validate().responseDecodable(of: [PortfolioRecord].self){ response in
            switch response.result {
                case .success(let value):
                    var updatedRecords: [PortfolioRecord] = []
                    
                    let dispatchGroup = DispatchGroup()
                    
                    value.forEach { record in
                        dispatchGroup.enter()
                        
                        self.fetchDetailsForPortfolioRecords(record) { updatedRecord in
                                // Update the record with the new data
                            updatedRecords.append(updatedRecord)
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                            // Update the entire array and notify observers
                        self.portfolioRecordsData = updatedRecords
                    }
                case .failure(let error):
                    print("add to portfolio \(error)")
            }
        }
    }
    
    func removePortfolioRecord(symbol: String) {
        let url = "\(baseUrl)/removeportfoliorecord?symbol=\(symbol)"
        AF.request(url).validate().responseDecodable(of: [PortfolioRecord].self){ response in
            switch response.result {
                case .success(let value):
                    var updatedRecords: [PortfolioRecord] = []
                    
                    let dispatchGroup = DispatchGroup()
                    
                    value.forEach { record in
                        dispatchGroup.enter()
                        
                        self.fetchDetailsForPortfolioRecords(record) { updatedRecord in
                                // Update the record with the new data
                            updatedRecords.append(updatedRecord)
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                            // Update the entire array and notify observers
                        self.portfolioRecordsData = updatedRecords
                    }
                case .failure(let error):
                    print("remove from portfolio \(error)")
            }
        }
    }
    
    func getPortfolio() {
        let url = "\(baseUrl)/getportfolio"
        AF.request(url).validate().responseDecodable(of: [PortfolioRecord].self) { response in
            switch response.result {
                case .success(let value):
                        //                    let json = JSON(value)
                        //                    let records = json.arrayValue.map { jsonRecord -> PortfolioRecord in
                        //                        return PortfolioRecord(
                        //                            stocksymbol: jsonRecord["stocksymbol"].stringValue,
                        //                            quantity: jsonRecord["quantity"].intValue,
                        //                            cost: jsonRecord["cost"].doubleValue
                        //                        )
                        //                    }
                    DispatchQueue.main.async {
                            //                        self.portfolioRecords = value
                    }
                case .failure(let error):
                    print("getPortfolio \(error)")
            }
        }
    }
    
    func getPortfolioRecordsData () {
        let url = "\(baseUrl)/getportfolio"
        AF.request(url).validate().responseDecodable(of: [PortfolioRecord].self) { response in
            switch response.result {
                case .success(let value):
                        //                    DispatchQueue.main.async {
                        //                        self.portfolioRecordsData = value
                        //                    }
                    var updatedRecords: [PortfolioRecord] = []
                    
//                    self.netWorth = 0
                    
                    let dispatchGroup = DispatchGroup()
                    
                    value.forEach { record in
                        dispatchGroup.enter()
                        
                        self.fetchDetailsForPortfolioRecords(record) { updatedRecord in
                                // Update the record with the new data
                            updatedRecords.append(updatedRecord)
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                            // Update the entire array and notify observers
                        self.portfolioRecordsData = updatedRecords
                    }
                    
                case .failure(let error):
                    print("getPortfolioRecordsData \(error)")
                    
            }
        }
    }
    
    
        //    func fetchDetailsForPortfolioRecords(_ record: PortfolioRecord, completion: @escaping (PortfolioRecord) -> Void) {
        //        print("i am in fetchDetailsForPortfolioRecords")
        //    }
    
    func fetchDetailsForPortfolioRecords(_ record: PortfolioRecord, completion: @escaping (PortfolioRecord) -> Void) {
        let companyInfoURL = "\(baseUrl)/company?symbol=\(record.stocksymbol.uppercased())"
        let stockPriceDetailsURL = "\(baseUrl)/latestPrice?symbol=\(record.stocksymbol.uppercased())"
        
        let dispatchGroup = DispatchGroup()
        
        var companyInfo: Details?
        var stockPriceDetails: StockPriceDetails?
        var portfolioRecord: PortfolioRecord? = record
        
        dispatchGroup.enter()
        AF.request(companyInfoURL).validate().responseDecodable(of: Details.self) { response in
            switch response.result {
                case .success(let value):
                    portfolioRecord?.companyName = value.name
                case .failure(let error):
                    print(error)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        AF.request(stockPriceDetailsURL).validate().responseDecodable(of: StockPriceDetails.self) { response in
            switch response.result {
                case .success(let value):
                    var currentValue = String(format: "%.2f", Float(value.c ?? 0.00))
                    if let currentValueFloat = Float(currentValue) {
                        let totalValue = Float(portfolioRecord?.quantity ?? 0) * currentValueFloat
                        portfolioRecord?.totalValue = Double(totalValue)
                        self.tempWorth = self.tempWorth + Double(totalValue)
                        self.netWorth = self.walletMoney + self.tempWorth
                        let averageCurrentCost = portfolioRecord!.cost / portfolioRecord!.quantity
                        let change = currentValueFloat - Float(averageCurrentCost)
                        portfolioRecord?.change = Double(change)
                        let changePercentage = (change/currentValueFloat)*100
                        portfolioRecord?.changePercentage = Double(changePercentage)
                        
                    } else {
                        print("Error converting currentValue to Float")
                    }
                case .failure(let error):
                    print("fetchDetailsForPortfolioRecords \(error)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
                //            if let index = self.portfolioRecordsData.firstIndex(where: { $0.id == record.id }) {
                //                    // Update the specific record in the array with the new data
                //                self.portfolioRecordsData[index] = portfolioRecord
                //            }
            
                // Notify observers by re-assigning the array
                //            self.portfolioRecordsData = self.portfolioRecordsData.map { $0 }
            completion(portfolioRecord!) // Assuming `portfolioRecord` is your updated record
            self.tempWorth = 0
            
        }
    }
    
    
    
        // Implement other methods similarly
    
        // Helper function for rounding doubles
    func rounded(toPlaces places: Double, forValue value: Double) -> Double {
        let divisor = pow(10.0, Double(places))
        return (value * divisor).rounded() / divisor
    }
}

extension Double {
        /// Rounds the double to decimal places value
    func rounded(toPlaces places:Double) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

