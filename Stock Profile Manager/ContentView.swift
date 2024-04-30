//
//  ContentView.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/3/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(PortfolioViewModel.self) var portfolioViewModel
    @Environment(FavoritesViewModel.self) var favoritesViewModel

    var body: some View {
//        VStack(alignment: .leading) {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            HStack {
//                Text("Hello, you!")
//                    .font(.title)
//                Spacer()
//                Text("Hi there!")
//                    .font(.subheadline)
//            }
//            .padding()
//
//        }
//        .padding()
        HomepageView()

    }
}

#Preview {
    ContentView()
        .environment(PortfolioViewModel())
        .environment(FavoritesViewModel())
}
