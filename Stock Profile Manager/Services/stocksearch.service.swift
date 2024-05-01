    //
    //  stocksearch.service.swift
    //  Stock Profile Manager
    //
    //  Created by Mansi Garg on 4/6/24.
    //

import Foundation
import Combine
import Alamofire
import Kingfisher
import SwiftyJSON

struct AutocompleteData: Identifiable, Decodable {
    let id = UUID()
    let displaySymbol: String
    let description: String
//    let type: String?
}

class StockSearchService: ObservableObject {
    private let baseURL = URL(string: "http://localhost:8000/api")!
    private var cancellables = Set<AnyCancellable>()
    @Published var stockPriceDetails: StockPriceDetails?
    @Published var companyInfo: Details?
    @Published var searchResults: [AutocompleteData] = []
    @Published var news: [NewsItem] = []

    @Published var isLoading: Bool = false
    
    
    
        //    @Published var currentStockDetail: StockDetail?
    
    
        //    func searchAutocomplete(query: String) {
        //        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
        //            self.searchResults = []
        //            return
        //        }
        //
        //        let queryItems = [URLQueryItem(name: "searchString", value: query)]
        //        var urlComponents = URLComponents(url: baseURL.appendingPathComponent("/search"), resolvingAgainstBaseURL: true)!
        //        urlComponents.queryItems = queryItems
        //
        //        var request = URLRequest(url: urlComponents.url!)
        //        request.httpMethod = "GET"
        //
        //        URLSession.shared.dataTaskPublisher(for: request)
        //            .map(\.data)
        //            .decode(type: [Stock].self, decoder: JSONDecoder())
        //            .receive(on: DispatchQueue.main) // Ensure UI updates are on the main thread
        //            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] stocks in
        //                self?.searchResults = stocks
        //            })
        //            .store(in: &cancellables)
        //    }
    
    func searchStock(stock: String) -> AnyPublisher<Details, Error> {
            //        let url = baseURL.appendingPathComponent("/symbol=$\(stock)")
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "symbol", value: stock)
        ]
        guard let url = components.url else { fatalError("Invalid URL components") }
        
        let result = URLSession.shared.dataTaskPublisher(for: url)
            .print("URLSession")
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)  // Or a custom error
                }
                if let jsonStr = String(data: data, encoding: .utf8) {
//                    print("Received JSON: \(jsonStr)")
                }
                return data
            }
            .decode(type: Details.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        result
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { details in
                print(details)
            })
            .store(in: &cancellables)
        print(result)
        return result
    }
    
    func fetchAutocompleteData(matching query: String, completion: @escaping ([AutocompleteData]) -> Void) {
        guard !query.isEmpty else {
            completion([])
            return
        }
        
        let url = "\(baseURL)/search?searchString=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    var symbols: [AutocompleteData] = []
                    
                        // Assuming the JSON response format is an array of objects
                    let items = json.arrayValue.filter { !$0["displaySymbol"].stringValue.contains(".") }
                    var uniqueSymbols = Set<String>()
                    let uniqueItems = items
                        .filter { $0["type"].stringValue == "Common Stock" } // Filter items with type "Common Stock"
                        .filter { uniqueSymbols.insert($0["displaySymbol"].stringValue).inserted }
                    
                    for item in uniqueItems as! [JSON] {
                        let displaySymbol = item["displaySymbol"].stringValue
                        let description = item["description"].stringValue
                        symbols.append(AutocompleteData(displaySymbol: displaySymbol, description: description))
                    }
                    
                    DispatchQueue.main.async {
                        completion(symbols)
                    }
                    
                case .failure(let error):
                    print("Error fetching symbols: \(error.localizedDescription)")
                    completion([])
            }
        }
    }
    
    func fetchCompanyInfo(forStock stock: String, completion: @escaping () -> Void) {
        let formattedStock = stock.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?.uppercased() ?? ""
        let url = "\(baseURL)/company?symbol=\(formattedStock)"
        
        AF.request(url).validate().responseDecodable(of: Details.self) { [weak self] response in
            print("Server Response (fetchCompanyInfo): \(response)")
            
            switch response.result {
                case .success(let details):
                    self?.fetchPeers(forStock: formattedStock) { peers in
                        DispatchQueue.main.async {
                            var detailsWithPeers = details
                            detailsWithPeers.peers = peers
                            self?.companyInfo = detailsWithPeers
                            completion()

                        }
                    }
                    
                case .failure(let error):
                    print("Error fetching company info: \(error)")                    
                    completion()

            }
        }
    }
    
    func fetchStockPriceDetails(forStock stock: String, completion: @escaping () -> Void) {
        let formattedStock = stock.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?.uppercased() ?? ""
        let url = "\(baseURL)/latestPrice?symbol=\(formattedStock)"
        print("url: \(url)")
        
            //        AF.request(url).validate().responseJSON { response in
            //            print("Server Response (fetchStockPriceDetails): \(response)")
            //
            //            switch response.result {
            //                case .success(let value):
            //                    let json = JSON(value)
            //                    print("JSON: \(json)")
            //                case .failure(let error):
            //                    print("Error fetching stock price details: \(error)")
            //            }
            //        }
        AF.request(url).validate().responseDecodable(of: StockPriceDetails.self) { response in
//            print("Server Response (fetchStockPriceDetails): \(response)")
            
            switch response.result {
                case .success(let stockPriceDetails):
                    DispatchQueue.main.async {
                            // Update your UI or data model as necessary
                        self.stockPriceDetails = stockPriceDetails
//                        print("Final Response (fetchStockPriceDetails): \(stockPriceDetails)")
                        completion()
                    }
                case .failure(let error):
                    completion()
                    print("Error fetching stock price details: \(error)")
            }
        }
    }
    
    func fetchPeers(forStock stock: String, completion: @escaping ([String]) -> Void) {
        let formattedStock = stock.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?.uppercased() ?? ""
        let url = "\(baseURL)/peers?symbol=\(formattedStock)"
        
        AF.request(url).validate().responseDecodable(of: [String].self) { response in
            switch response.result {
                case .success(let peers):
                    let uniquePeers = Set(peers)
                    let filteredPeers = Array(uniquePeers.filter { !$0.contains(".") })
//                    print("Filtered Peers: \(filteredPeers)")
                    completion(filteredPeers)
                    
                case .failure(let error):
                    print("Error fetching peers: \(error)")
                    completion([])
            }
        }
    }
    
    func fetchNews(forStock stockSymbol: String, completion: @escaping () -> Void) {
        let today = Date()
        let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: today)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        let sixMonthsAgoString = dateFormatter.string(from: sixMonthsAgo)
        let url = URL(string: "\(baseURL)/news?symbol=\(stockSymbol)&fromDate=\(sixMonthsAgoString)&toDate=\(todayString)")!
        AF.request(url).validate().responseDecodable(of: [NewsItem].self) { response in
            switch response.result {
                case .success(let newsItems):
                    let filteredNews = newsItems.filter { 
                            // Check if each property is non-nil and not empty
                        $0.headline?.isEmpty == false && 
                        $0.summary?.isEmpty == false &&
                        $0.image?.isEmpty == false && 
                        $0.url?.isEmpty == false && 
                        $0.source?.isEmpty == false
                    }.prefix(20)
                    self.news = Array(filteredNews)
                    
                    completion()
                    
                case .failure(let error):
                    print("Error fetching news: \(error.localizedDescription)")
                    
                    completion()
            }
        }
    }
    
    func fetchAllData(forStock stock: String) {
        self.isLoading = true
        let minimumDisplayTime = DispatchTime.now() + 0.5 // 500 ms

        let dispatchGroup = DispatchGroup()
        
        let complete = {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchCompanyInfo(forStock: stock, completion: complete)
        
        dispatchGroup.enter()
        fetchStockPriceDetails(forStock: stock, completion: complete)
        
        dispatchGroup.enter()
        fetchNews(forStock: stock, completion: complete)
        
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.asyncAfter(deadline: minimumDisplayTime) {
                self.isLoading = false
            }
        }
    }

    
    
    
}

struct StockDetail: Codable {
        // Define properties matching your backend's stock detail JSON structure
}
