//
//  FavoriteViewModel.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/11/24.
//

import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
    @Published var favoritesEntries: [FavoriteEntry] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var service = FavoritesService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bindService()
    }
    
    private func bindService() {
        service.$favoritesEntries
            .assign(to: \.favoritesEntries, on: self)
            .store(in: &cancellables)
    }
    
    func fetchFavorites() {
        isLoading = true
        service.getFavoritesData()
            // Assuming FavoritesService has a @Published property or similar mechanism to observe changes
        service.$favoritesEntries
            .receive(on: DispatchQueue.main)
            .sink { [weak self] entries in
                self?.favoritesEntries = entries
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func addToFavorites(symbol: String) {
        service.addToFavorites(symbol: symbol) { [weak self] success in
            if success {
                self?.fetchFavorites() // Refresh the list after adding
            } else {
                self?.errorMessage = "Failed to add to favorites."
            }
        }
    }
    
    func removeFromFavorites(symbol: String) {
        service.removeFromFavorites(symbol: symbol) { [weak self] success in
            if success {
                self?.fetchFavorites() // Refresh the list after removing
            } else {
                self?.errorMessage = "Failed to remove from favorites."
            }
        }
    }
    
    func clearFavorites() {
        service.clearFavoritesData()
            // Refresh the local list immediately, assuming the service clears its list instantly
        favoritesEntries.removeAll()
    }
}
