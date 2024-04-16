//
//  PortfolioViewModel.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/7/24.
//

import Foundation
import Combine

@Observable
class PortfolioViewModel {
        // MARK: - Properties
    var walletMoney: Double = 0
    let updateSignal = PassthroughSubject<Void, Never>()

    var portfolioRecordsData: [PortfolioRecord] = []
    var netWorth: Double = 0
    
        // MARK: - Private Properties
    
    private let service = PortfolioService()
    private var cancellables: Set<AnyCancellable> = []
    
        // MARK: - Init
    init() {
        bindService()
        setupUpdateListener()
    }
    
    private func setupUpdateListener() {
        updateSignal
            .debounce(for: .seconds(1), scheduler: RunLoop.main) // Adjust timing as needed
            .sink { [weak self] in
                self?.refreshData()
            }
            .store(in: &cancellables)
    }
    
    func refreshData() {
            // Refresh your data here
        fetchWalletMoney()
        getPortfolioRecordsData()
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
    
    func updatePortfolioRecord(symbol: String, quantity: Double, price: Double) {
        service.updatePortfolioRecord(symbol: symbol, quantity: quantity, price: price)
    }
    
    func getPortfolio() {
        service.getPortfolio()
    }
    
    func getPortfolioRecordsData() {
        service.getPortfolioRecordsData()
        print("portfolioRecordsData: \(portfolioRecordsData)")
    }
    
}


