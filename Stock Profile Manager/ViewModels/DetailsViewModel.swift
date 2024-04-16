    //
    //  DetailsViewModel.swift
    //  Stock Profile Manager
    //
    //  Created by Mansi Garg on 4/6/24.
    //

import Foundation
import SwiftUI
import Combine

import Combine

@Observable
class DetailsViewModel {
    var searchString: String = "" {
        didSet {
            fetchData(for: searchString)
        }
    }
    var companyInfo: Details?
    var stockPriceDetails: StockPriceDetails?
    var isLoading: Bool = false
    var news: [NewsItem]?
    
    private var cancellables = Set<AnyCancellable>()
    private let stockSearchService = StockSearchService()
    
    init() {
        observeServiceUpdates()
    }
    
    private func fetchData(for searchString: String) {
        guard !searchString.isEmpty else {
            clearData()
            return
        }
        isLoading = true
        stockSearchService.fetchAllData(forStock: searchString)
    }
    
    private func clearData() {
        companyInfo = nil
        stockPriceDetails = nil
        news = nil
        isLoading = false
    }
    
//    private func observeServiceUpdates() {
//        stockSearchService.$companyInfo
//            .assign(to: \.companyInfo, on: self)
//            .store(in: &cancellables)
//        
//        stockSearchService.$stockPriceDetails
//            .assign(to: \.stockPriceDetails, on: self)
//            .store(in: &cancellables)
//        
//        stockSearchService.$news
//            .assign(to: \.news, on: self)
//            .store(in: &cancellables)
//        
//        stockSearchService.$isLoading
//            .assign(to: \.isLoading, on: self)
//            .store(in: &cancellables)
//    }
    private func observeServiceUpdates() {
        stockSearchService.$companyInfo
            .sink { [weak self] newCompanyInfo in
                self?.companyInfo = newCompanyInfo
            }
            .store(in: &cancellables)
        
        stockSearchService.$stockPriceDetails
            .sink { [weak self] newStockPriceDetails in
                self?.stockPriceDetails = newStockPriceDetails
            }
            .store(in: &cancellables)
        
        stockSearchService.$news
            .sink { [weak self] newNews in
                self?.news = newNews
            }
            .store(in: &cancellables)
        
        stockSearchService.$isLoading
            .sink { [weak self] newIsLoading in
                self?.isLoading = newIsLoading
            }
            .store(in: &cancellables)
    }
}
