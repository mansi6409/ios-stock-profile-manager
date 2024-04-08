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
    var quantity: Int
    var cost: Double
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
    @Published private(set) var portfolioRecords: [PortfolioRecord] = []
    
    init() {
        fetchWalletMoney()
        getPortfolio()
    }
    
    func fetchWalletMoney() {
        let url = "\(baseUrl)/getwalletmoney"
        print("fetchWalletMoney url: \(url)")
        AF.request(url).validate().responseDecodable(of: [WalletMoney].self) { [weak self] response in
            print("fetchWalletMoney response: \(response)")
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
        
        AF.request(url).validate().responseDecodable(of: WalletMoney.self)  { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func addPortfolioRecord(symbol: String, quantity: Int, price: Double) {

        let url = "\(baseUrl)/addportfoliorecord?symbol=\(symbol),stockquantity=\(quantity),price=\(price)"
        AF.request(url).validate().responseDecodable(of: [PortfolioRecord].self){ response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    let records = json.arrayValue.map { jsonRecord -> PortfolioRecord in
                        return PortfolioRecord(
                            stocksymbol: jsonRecord["stocksymbol"].stringValue,
                            quantity: jsonRecord["quantity"].intValue,
                            cost: jsonRecord["cost"].doubleValue
                        )
                    }
                    DispatchQueue.main.async {
                        self.portfolioRecords = records
                    }
                case .failure(let error):
                    print(error)
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
                        self.portfolioRecords = value
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
        // Implement other methods similarly
    
        // Helper function for rounding doubles
    func rounded(toPlaces places: Int, forValue value: Double) -> Double {
        let divisor = pow(10.0, Double(places))
        return (value * divisor).rounded() / divisor
    }
}

extension Double {
        /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

