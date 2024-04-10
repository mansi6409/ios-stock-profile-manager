    //
    //  HomepageView.swift
    //  Stock Profile Manager
    //
    //  Created by Mansi Garg on 4/5/24.
    //

import SwiftUI

struct HomepageView: View {
    @State private var searchString = ""
    @StateObject private var detailsViewModel = DetailsViewModel()
    @StateObject private var autocompleteViewModel = AutocompleteViewModel()
    
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            VStack {
                if searchString.isEmpty {
                    DetailsView(viewModel: detailsViewModel)
                        .navigationTitle("Stocks")
                        .navigationBarItems(trailing: EditButton())
                } else {
                    AutocompleteView(searchText: $searchString, viewModel: autocompleteViewModel)
                }
            }
            .searchable(text: $searchString, prompt: "Search for stocks")
            .onChange(of: searchString) { newValue in
                autocompleteViewModel.queryChanged(to: newValue)
            }
            
        }
        .padding(0.0)
    }
}

#Preview {
    HomepageView()
}
