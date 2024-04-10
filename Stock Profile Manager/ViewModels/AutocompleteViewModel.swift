//
//  AutocompleteViewModel.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/9/24.
//

import Foundation

private var debounceWorkItem: DispatchWorkItem?
import Combine

class AutocompleteViewModel: ObservableObject {
    @Published var searchResults = [AutocompleteData]()
    
    private let stockSearchService = StockSearchService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
    }
    
    func queryChanged(to query: String) {
        debounceWorkItem?.cancel() // Cancel the previous work item
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.fetchAutocompleteData(matching: query)
        }
        
            // Assign the new work item and schedule it to run after a delay
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
    
    func fetchAutocompleteData(matching query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.searchResults = []
            return
        }
        
        stockSearchService.fetchAutocompleteData(matching: query) { [weak self] results in
            DispatchQueue.main.async {
                self?.searchResults = results
            }
        }
    }
    
    func setupSearchStringPublisher(searchStringPublisher: Published<String>.Publisher) {
        searchStringPublisher
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchString in
                self?.fetchAutocompleteData(matching: searchString)
            }
            .store(in: &cancellables)
    }
}
