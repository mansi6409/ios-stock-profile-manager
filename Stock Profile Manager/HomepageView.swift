    //
    //  HomepageView.swift
    //  Stock Profile Manager
    //
    //  Created by Mansi Garg on 4/5/24.
    //

import SwiftUI

struct HomepageView: View {
    @State private var searchString = ""
    @State var detailsViewModel = DetailsViewModel()
    @StateObject private var autocompleteViewModel = AutocompleteViewModel()
    @Environment(FavoritesViewModel.self) var favoritesViewModel
    @Environment(PortfolioViewModel.self) var portfolioViewModel
    
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            VStack {
                if searchString.isEmpty {
                    DetailsView()
                        .navigationTitle("Stocks")
                        .navigationBarItems(trailing: EditButton())
                        .environment(detailsViewModel)
                        .environment(portfolioViewModel)
                        .environment(favoritesViewModel)
                    
                } else {
                    AutocompleteView(searchText: $searchString, viewModel: autocompleteViewModel)
                        .environment(detailsViewModel)
                        .navigationTitle("Stocks")
                        .navigationBarTitleDisplayMode(.inline)
                    
                }
            }
            .searchable(text: $searchString, prompt: "Search for stocks")
            .onChange(of: searchString) { newValue in
                autocompleteViewModel.queryChanged(to: newValue)
            }
            
        }
        .padding(0.0)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HomepageView()
        .environment(PortfolioViewModel())
        .environment(FavoritesViewModel())
}
