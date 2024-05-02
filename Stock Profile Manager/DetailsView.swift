    //
    //  DetailsView.swift
    //  Stock Profile Manager
    //
    //  Created by Mansi Garg on 4/6/24.
    //

import SwiftUI

struct DetailsView: View {
//    @ObservedObject var viewModel = DetailsViewModel()
    @Environment(DetailsViewModel.self) var viewModel

//    @ObservedObject private var portfolioViewModel = PortfolioViewModel()
    @Environment(PortfolioViewModel.self) var portfolioViewModel
    @Environment(FavoritesViewModel.self) var favoritesViewModel
//    @State private var isFavorite: Bool = false

    
    var body: some View {
        List{
            HStack {
                Spacer()
                Text(currentDateString())
                    .bold()
                    .foregroundColor(.gray)
                    .padding(.vertical)
                    .padding(.horizontal, 10.0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(9)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    //                Spacer()
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal, -26)
                //            .padding(.horizontal, 0)
            .listRowBackground(Color(.systemGroupedBackground))
//            Text("\(viewModel.stockPriceDetails?.c ?? 0.0)")
//                .padding(.top, 10)
//                .padding(.horizontal, 10)
//                .padding(.bottom, 10)
            Section(header: Text("PORTFOLIO")) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Net Worth")
//                            .font(.headline)
                            .font(.system(size: 21))
                        Text(String(format: "$%.2f", portfolioViewModel.netWorth))
                            .bold()
                            .font(.system(size: 20))
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Cash Balance")
                            .font(.system(size: 21))
                        Text(String(format: "$%.2f", portfolioViewModel.walletMoney))
                          .bold()
                            .font(.system(size: 20))
                    }
                }
                .padding(.bottom, 5)
                .padding(.top, 4)
                ForEach(portfolioViewModel.portfolioRecordsData.indices, id: \.self) { index in
                    NavigationLink(destination: StockDataView(symbol: portfolioViewModel.portfolioRecordsData[index].stocksymbol)
                        .environment(viewModel)
                    ) {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(portfolioViewModel.portfolioRecordsData[index].stocksymbol)")
                                    .bold()
                                    .font(.system(size: 20))
                                Text("\(Int(portfolioViewModel.portfolioRecordsData[index].quantity)) shares")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("$\(portfolioViewModel.portfolioRecordsData[index].totalValue ?? 0.00, specifier: "%.2f")")
                                    .bold()
                                    .font(.system(size: 16))
                                HStack(spacing: 2) {
                                    if let change = portfolioViewModel.portfolioRecordsData[index].change, change != 0 {
                                        Image(systemName: (change > 0 ? "arrow.up.forward" : (change < 0 ? "arrow.down.forward" : "minus")))
                                            .foregroundColor(change > 0 ? .green : (change < 0 ? .red : .black))
                                            .padding(.trailing, 6)
                                    }
                                    Text("$\((portfolioViewModel.portfolioRecordsData[index].change ?? 0 * portfolioViewModel.portfolioRecordsData[index].quantity ?? 0), specifier: "%.2f") (\(portfolioViewModel.portfolioRecordsData[index].changePercentage ?? 0, specifier: "%.2f")%)")
                                        .foregroundColor(portfolioViewModel.portfolioRecordsData[index].change ?? 0 > 0 ? .green : (portfolioViewModel.portfolioRecordsData[index].change ?? 0 < 0 ? .red : .black))
                                }
                                .font(.system(size: 16))}
                        }
                        
                            //                    RightAlignedDivider()
                    }
                }
//                .onDelete(perform: deletePortfolioItem)
                .onMove(perform: movePortfolioItem)

            }
            
            
            Section(header: Text("FAVORITES")) {
                ForEach(favoritesViewModel.favoritesEntries.indices, id: \.self) { index in
                    NavigationLink(destination: StockDataView(symbol: favoritesViewModel.favoritesEntries[index].symbol)
                        .environment(viewModel)
//                        .navigationBarItems(trailing: Button(action: {
//                            isFavorite.toggle()
//                            if isFavorite {
//                                favoritesViewModel.addToFavorites(symbol: favoritesViewModel.favoritesEntries[index].symbol)
//                            } else {
//                                favoritesViewModel.removeFromFavorites(symbol: favoritesViewModel.favoritesEntries[index].symbol)
//                            }
//                                // Call your backend function depending on the isFavorite state
//                        }) {
//                            Image(systemName: isFavorite ? "plus.circle.fill" : "plus.circle")
//                                .imageScale(.large)
//                                .foregroundColor(.blue)
//                        })
                    ) {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(favoritesViewModel.favoritesEntries[index].symbol)")
                                    .bold()
                                    .font(.system(size: 20))
                                Text("\(favoritesViewModel.favoritesEntries[index].companyName ?? "")")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("$\(favoritesViewModel.favoritesEntries[index].stockPrice ?? 0.00, specifier: "%.2f")")
                                    .bold()
                                    .font(.system(size: 16))
                                HStack(spacing: 2) {
                                    if let change = favoritesViewModel.favoritesEntries[index].change, change != 0 {
                                        Image(systemName: change > 0 ? "arrow.up.forward" : "arrow.down.forward")
                                            .foregroundColor(change > 0 ? .green : .red)
                                            .padding(.trailing, 6)
                                    }
                                    Text("$\(favoritesViewModel.favoritesEntries[index].change ?? 0, specifier: "%.2f") (\(favoritesViewModel.favoritesEntries[index].changePercentage ?? 0, specifier: "%.2f")%)")
                                        .foregroundColor(favoritesViewModel.favoritesEntries[index].change == 0 ? .black : (favoritesViewModel.favoritesEntries[index].change ?? 0 > 0 ? .green : .red))
                                }
                                .font(.system(size: 16))}
                        }
                        
                            //                    RightAlignedDivider()
                    }
                }
                .onDelete(perform: deleteFavoriteItem)
                .onMove(perform: moveFavoriteItem)

            }
            
            Section {
                Link(destination: URL(string: "https://finnhub.io")!) {
                    HStack {
                        Spacer()
                        Text("Powered by Finnhub.io")
                            .foregroundColor(.gray)
                            .padding(.vertical)
                            .padding(.horizontal, -6)
                            .frame( width: 350, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(9)
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding()
                }
            }
            .listRowBackground(Color(.systemGroupedBackground))
            .listStyle(PlainListStyle())
            .padding(.horizontal, -26)
            
            
        }.background(Color(.systemGroupedBackground))
    }
    
    func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: Date())
    }
    
    func deleteFavoriteItem(at offsets: IndexSet) {
            // Remove the item from the favorites entries
//        favoritesViewModel.favoritesEntries.remove(atOffsets: offsets)
        print("i am trying to delete fav item")
//        print(offsets)
        let symbolsToDelete = offsets.map { favoritesViewModel.favoritesEntries[$0].symbol }
        for symbol in symbolsToDelete {
            print("Deleting item with symbol: \(symbol)")
                // Assuming you have a function to handle the deletion by symbol
            deleteItemBySymbol(symbol)
        }
    }
    
    private func deleteItemBySymbol(_ symbol: String) {
            // Your code to handle deletion by symbol, maybe updating the backend or local storage
        print("Remove the item with symbol: \(symbol) from backend or database")
        favoritesViewModel.removeFromFavorites(symbol: symbol)
    }
    
    private func movePortfolioItem(from source: IndexSet, to destination: Int) {
//        portfolioViewModel.portfolioRecordsData.move(fromOffsets: source, toOffset: destination)
        print("i am trying to move portfolio item")
    }
    
    private func moveFavoriteItem(from source: IndexSet, to destination: Int) {
//        favoritesViewModel.favoritesEntries.move(fromOffsets: source, toOffset: destination)
        print("i am trying to move fav item")

    }

}

    #Preview {
        DetailsView()
            .environment(PortfolioViewModel())
            .environment(DetailsViewModel())
            .environment(FavoritesViewModel())
    }

//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView(viewModel: DetailsViewModel())
//    }
//}
struct RightAlignedDivider: View {
    var body: some View {
        HStack {
            Spacer() // Pushes the divider to the right
            Divider() // The actual divider
                .frame(width: UIScreen.main.bounds.width * 0.9) // Set the width of your divider line
        }
    }
}
