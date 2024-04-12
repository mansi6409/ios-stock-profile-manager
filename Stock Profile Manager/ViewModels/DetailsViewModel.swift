//
//  DetailsViewModel.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/6/24.
//

import Foundation
import SwiftUI
import Combine

class DetailsViewModel: ObservableObject {
    @Published var searchString: String = ""
//    @Published var stockDetail: Details?
    @Published var companyInfo: Details?
    @Published var stockPriceDetails: StockPriceDetails?
    @Published var isLoading: Bool?

    private var cancellables = Set<AnyCancellable>()
    private let stockSearchService = StockSearchService()
    
    init() {
//        $searchString
//            .debounce(for: 0.5, scheduler: DispatchQueue.main) // Wait for 0.5 seconds after typing stops
//            .removeDuplicates() // Only search if the new value is different from the last one
//            .flatMap { searchString -> AnyPublisher<Details, Never> in
//                guard !searchString.isEmpty else {
//                    return Just(Details()).eraseToAnyPublisher() // Return an empty result if the search string is empty
//                }
//                return self.stockSearchService.searchStock(stock: searchString)
//                    .catch { _ in Just(Details()) } // Handle errors by returning an empty result
//                    .eraseToAnyPublisher()
////                return result
//            }
//            .receive(on: DispatchQueue.main)
//            .sink(receiveValue: { [weak self] stockDetail in
//                self?.stockDetail = stockDetail
//            })
//            .store(in: &cancellables)
        $searchString
            .debounce(for: 0.5, scheduler: DispatchQueue.main) // Wait for 0.5 seconds after typing stops
            .removeDuplicates() // Only search if the new value is different from the last one
            .sink { searchString in
                guard !searchString.isEmpty else {
                        // Clear the current data if the search string is empty
                    self.companyInfo = nil
                    self.stockPriceDetails = nil
                    return
                }
                self.stockSearchService.fetchAllData(forStock: searchString)
            }
            .store(in: &cancellables)
            // Observe the companyInfo and stockPriceDetails from the StockSearchService
        stockSearchService.$companyInfo
            .sink { [weak self] in self?.companyInfo = $0 }
            .store(in: &cancellables)
        stockSearchService.$stockPriceDetails
            .sink { [weak self] in self?.stockPriceDetails = $0 }
            .store(in: &cancellables)
        
        
    }
}


