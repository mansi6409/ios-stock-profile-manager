//
//  HomepageView.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/5/24.
//

import SwiftUI

struct HomepageView: View {
    @State private var searchString = ""

    var body: some View {
        NavigationView {
//                    VStack {
                        DetailsView()
//                    }
                .searchable(text: $searchString, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
                .navigationTitle("Stocks")
                .navigationBarItems(trailing: EditButton())
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
