    //
    //  AutocompleteView.swift
    //  Stock Profile Manager
    //
    //  Created by Mansi Garg on 4/9/24.
    //

import SwiftUI

struct AutocompleteView: View {
    @Binding var searchText: String
        //    @Binding var isSearching: Bool
    
    @ObservedObject var viewModel = AutocompleteViewModel()
    @Environment(DetailsViewModel.self) var detailsViewModel
    
    var body: some View {
            //        NavigationView {
        searchResultsList
            //                .navigationBarTitle("Search Stocks", displayMode: .inline)
            //                .searchable(text: $searchText, prompt: "Search for stocks")
            ////                .onChange(of: searchText, perform: viewModel.fetchAutocompleteData)
            //                .background(Color(.systemGroupedBackground))
            //                .navigationTitle("Stocks")
        
            //        }
    }
    
    private var searchResultsList: some View {
        List(viewModel.searchResults, id: \.displaySymbol) { result in
            searchResultRow(for: result)
        }
//        .padding()
//        .listStyle(PlainListStyle())
        .background(Color(.systemGroupedBackground))
    }
    
    private func searchResultRow(for result: AutocompleteData) -> some View {
        NavigationLink(destination: StockDataView( symbol: result.displaySymbol)            .environment(detailsViewModel)
        ) {
            VStack(alignment: .leading) {
                Text("\(result.displaySymbol)")
                    .font(.system(size: 20))
                    .bold()
                Text("\(result.description)")
                    .foregroundColor(.gray)
                    .font(.system(size: 18))
            }
//            .padding(./*vertical*/)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AutocompleteView(searchText: .constant(""))
        .environment(DetailsViewModel()
        )
}
