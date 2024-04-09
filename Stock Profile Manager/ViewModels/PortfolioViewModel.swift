//
//  PortfolioViewModel.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/7/24.
//

import Foundation
import Combine

class PortfolioViewModel: ObservableObject {
        // MARK: - Properties
    @Published var walletMoney: Double = 0
    @Published var portfolioRecordsData: [PortfolioRecord] = []
    @Published var netWorth: Double = 0
    
        // MARK: - Private Properties
    
    private let service = PortfolioService()
    private var cancellables: Set<AnyCancellable> = []
    
        // MARK: - Init
    init() {
        bindService()
    }
    
        // MARK: - Methods to bind service to the ViewModel
    private func bindService() {
        service.$walletMoney
            .assign(to: \.walletMoney, on: self)
            .store(in: &cancellables)
        
        service.$portfolioRecordsData
            .assign(to: \.portfolioRecordsData, on: self)
            .store(in: &cancellables)
        
        service.$netWorth
            .assign(to: \.netWorth, on: self)
            .store(in: &cancellables)
    }
    
        // MARK: - Service Interaction
    func fetchWalletMoney() {
        service.fetchWalletMoney()
    }
    
    func updateWalletMoney(amount: Double) {
        service.updateWalletMoney(amount: amount)
    }
    
    func addPortfolioRecord(symbol: String, quantity: Double, price: Double) {
        service.addPortfolioRecord(symbol: symbol, quantity: quantity, price: price)
    }
    
    func getPortfolio() {
        service.getPortfolio()
    }
    
        // Add other methods that you need to interact with the PortfolioService
}


