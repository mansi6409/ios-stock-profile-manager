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
    
    
    var body: some View {
        NavigationView {
                //                    VStack {
            DetailsView(viewModel: detailsViewModel)
                .searchable(text: $detailsViewModel.searchString, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
                .navigationTitle("Stocks")
                .navigationBarItems(trailing: EditButton())//                    }
                .searchable(text: $searchString, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
                .toolbar {
                }
        }
        .padding(0.0)
        
            //        .foregroundColor(Color.gray)
            //        .background(Color.green.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    HomepageView()
}
