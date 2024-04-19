    //
    //  favorites.service.swift
    //  Stock Profile Manager
    //
    //  Created by Mansi Garg on 4/7/24.
    //

import Foundation
import Alamofire
import SwiftyJSON
import Combine

struct FavoriteEntry:  Codable, Identifiable {
    let id = UUID()
    var symbol: String
    var companyName: String?
    var stockPrice: Double?
    var changePercentage: Double?
    var change: Double?
}

class FavoritesService {
        //static let shared = FavoritesService() // Singleton instance
    private let baseUrl = "http://localhost:8000/api"
    @Published private(set) var favoritesEntries: [FavoriteEntry] = []
    
    
    init() {
        getFavoritesData()
    }
    
    
        // Fetch favorites
        //    func fetchFavorites(completion: @escaping ([FavoriteEntry]?) -> Void) {
        //        let url = "\(baseUrl)/getwatchlist"
        //        AF.request(url).responseJSON { response in
        //            switch response.result {
        //                case .success(let value):
        //                    let json = JSON(value)
        //                    self.favoritesEntries = json.arrayValue.map { FavoriteEntry(symbol: $0["symbol"].stringValue,
        //                                                                                companyName: $0["companyName"].string,
        //                                                                                stockPrice: $0["stockPrice"].double,
        //                                                                                changePercentage: $0["changePercentage"].double,
        //                                                                                changeAmount: $0["changeAmount"].double) }
        //                    completion(self.favoritesEntries)
        //                case .failure(let error):
        //                    print("Error fetching favorites: \(error)")
        //                    completion(nil)
        //            }
        //        }
        //    }
    
        // Add to favorites
    func addToFavorites(symbol: String, completion: @escaping (Bool) -> Void) {
        let url = "\(baseUrl)/addwatchlist"
        AF.request(url, parameters: ["symbol": symbol]).responseJSON { response in
            switch response.result {
                case .success(let value):
                    var updatedRecords: [FavoriteEntry] = []
                    
                    let dispatchGroup = DispatchGroup()
                    (value as? [FavoriteEntry])!.forEach { record in
                        dispatchGroup.enter()
                        
                        self.fetchDetailsForFavoriteRecords(record: record) { updatedRecord in
                                // Update the record with the new data
                            updatedRecords.append(updatedRecord)
                            dispatchGroup.leave()
                        }
                    }
                    dispatchGroup.notify(queue: .main) {
                            // Update the entire array and notify observers
                        self.favoritesEntries = updatedRecords
                    }
                    completion(true)
                case .failure(let error):
                    print("Error adding to favorites: \(error)")
                    completion(false)
                    
            }
        }
    }
    
        // Remove from favorites
//    func removeFromFavorites(symbol: String, completion: @escaping (Bool) -> Void) {
//        let url = "\(baseUrl)/removewatchlist"
//        AF.request(url, parameters: ["symbol": symbol]).responseJSON { response in
//            switch response.result {
//                case .success(let value):
//                    var updatedRecords: [FavoriteEntry] = []
//                    
//                    let dispatchGroup = DispatchGroup()
//                    (value as? [FavoriteEntry])!.forEach { record in
//                        dispatchGroup.enter()
//                        
//                        self.fetchDetailsForFavoriteRecords(record: record) { updatedRecord in
//                                // Update the record with the new data
//                            updatedRecords.append(updatedRecord)
//                            dispatchGroup.leave()
//                        }
//                    }
//                    dispatchGroup.notify(queue: .main) {
//                            // Update the entire array and notify observers
//                        self.favoritesEntries = updatedRecords
//                    }
//                    completion(true)
//                case .failure(let error):
//                    print("Error removing from favorites: \(error)")
//                    completion(false)
//            }
//        }
//    }
    
    func removeFromFavorites(symbol: String, completion: @escaping (Bool) -> Void) {
        let url = "\(baseUrl)/removewatchlist"
        AF.request(url, parameters: ["symbol": symbol]).responseJSON { response in
            switch response.result {
                case .success(let value):
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) else {
                        completion(false)
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let updatedRecords = try decoder.decode([FavoriteEntry].self, from: jsonData)
                        let dispatchGroup = DispatchGroup()
                        var finalRecords: [FavoriteEntry] = []
                        for record in updatedRecords {
                            dispatchGroup.enter()
                            self.fetchDetailsForFavoriteRecords(record: record) { updatedRecord in
                                finalRecords.append(updatedRecord)
                                dispatchGroup.leave()
                            }
                        }
                        dispatchGroup.notify(queue: .main) {
                            self.favoritesEntries = finalRecords
                            completion(true)
                        }
                    } catch {
                        print("Decoding error: \(error)")
                        completion(false)
                    }
                case .failure(let error):
                    print("Error removing from favorites: \(error)")
                    completion(false)
            }
        }
    }

    
        // Fetch detailed favorites data
    func getFavoritesData() {
        let url = "\(baseUrl)/getwatchlist"
        AF.request(url).validate().responseDecodable(of: [FavoriteEntry].self) { response in
            switch response.result {
                case .success(let value):
                    var updatedRecords: [FavoriteEntry] = []
                    
                    let dispatchGroup = DispatchGroup()
                    value.forEach { record in
                        dispatchGroup.enter()
                        
                        self.fetchDetailsForFavoriteRecords(record: record) { updatedRecord in
                                // Update the record with the new data
                            updatedRecords.append(updatedRecord)
                            dispatchGroup.leave()
                        }
                    }
                    dispatchGroup.notify(queue: .main) {
                            // Update the entire array and notify observers
                        self.favoritesEntries = updatedRecords
                    }
                case .failure(let error):
                    print("Error fetching favorites: \(error)")
            }
        }
    }
    
    func fetchDetailsForFavoriteRecords( record: FavoriteEntry, completion: @escaping (FavoriteEntry) -> Void) {
        let companyInfoURL = "\(baseUrl)/company?symbol=\(record.symbol.uppercased())"
        let stockPriceDetailsURL = "\(baseUrl)/latestPrice?symbol=\(record.symbol.uppercased())"
        
        let dispatchGroup = DispatchGroup()
        
        var companyInfo: Details?
        var stockPriceDetails: StockPriceDetails?
        var favoriteRecord: FavoriteEntry? = record
        
        dispatchGroup.enter()
        AF.request(companyInfoURL).validate().responseDecodable(of: Details.self) { response in
            switch response.result {
                case .success(let value):
                    favoriteRecord?.companyName = value.name
                case .failure(let error):
                    print(error)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        AF.request(stockPriceDetailsURL).validate().responseDecodable(of: StockPriceDetails.self) { response in
            switch response.result {
                case .success(let value):
                    favoriteRecord?.stockPrice = Double(value.c ?? 0.00)
                    favoriteRecord?.change = Double(value.d ?? 0.00)
                    favoriteRecord?.changePercentage = Double(value.dp ?? 0.00)
                    
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
            completion(favoriteRecord!) // Assuming `portfolioRecord` is your updated record
            
        }
    }
    
        // Clear favorites data
    func clearFavoritesData() {
        favoritesEntries.removeAll()
    }
}

