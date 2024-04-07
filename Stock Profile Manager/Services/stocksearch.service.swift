//
//  stocksearch.service.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/6/24.
//

import Foundation
import Combine

class StockSearchService: ObservableObject {
    private let baseURL = URL(string: "http://localhost:8000/api/company")!
    private var cancellables = Set<AnyCancellable>()
    
        // Use @Published for properties that need to be observed by the UI
    @Published var searchResults: [Stock] = []
    @Published var currentStockDetail: StockDetail?
    

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
                    print("Received JSON: \(jsonStr)")
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
    
}

    // Example structs for decoding JSON
struct Stock: Codable, Identifiable {
    var id: String
    var symbol: String
    var quantity: Int
    var cost: Double
}

struct StockDetail: Codable {
        // Define properties matching your backend's stock detail JSON structure
}
