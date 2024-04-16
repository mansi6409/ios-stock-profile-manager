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
    @ObservedObject private var favoritesViewModel = FavoritesViewModel()
    
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
                            .font(.system(size: 18))
                        Text("$\(portfolioViewModel.netWorth, specifier: "%.2f")")
                            .bold()
                            .font(.system(size: 18))
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Cash Balance")
                            .font(.system(size: 18))
                        Text("$\(portfolioViewModel.walletMoney, specifier: "%.2f")")
                          .bold()
                            .font(.system(size: 18))
                    }
                }
                .padding()
                ForEach(portfolioViewModel.portfolioRecordsData.indices, id: \.self) { index in
                    NavigationLink(destination: StockDataView(symbol: portfolioViewModel.portfolioRecordsData[index].stocksymbol)
                        .environment(viewModel)) {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(portfolioViewModel.portfolioRecordsData[index].stocksymbol)")
                                    .bold()
                                    .font(.system(size: 20))
                                Text("\(Int(portfolioViewModel.portfolioRecordsData[index].quantity)) Shares")
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
                                        Image(systemName: change > 0 ? "arrow.up.forward" : "arrow.down.forward")
                                            .foregroundColor(change > 0 ? .green : .red)
                                            .padding(.trailing, 6)
                                    }
                                    Text("$\(portfolioViewModel.portfolioRecordsData[index].change ?? 0, specifier: "%.2f") (\(portfolioViewModel.portfolioRecordsData[index].changePercentage ?? 0, specifier: "%.2f")%)")
                                        .foregroundColor(portfolioViewModel.portfolioRecordsData[index].change == 0 ? .black : (portfolioViewModel.portfolioRecordsData[index].change ?? 0 > 0 ? .green : .red))
                                }
                                .font(.system(size: 16))}
                        }
                        
                            //                    RightAlignedDivider()
                    }
                }
            }
            
            
            Section(header: Text("FAVORITES")) {
                ForEach(favoritesViewModel.favoritesEntries.indices, id: \.self) { index in
                    NavigationLink(destination: StockDataView(symbol: favoritesViewModel.favoritesEntries[index].symbol)
                        .environment(viewModel)) {
                        
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
            }
            
            
        }.background(Color(.systemGroupedBackground))
    }
    
    func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: Date())
    }
}

    #Preview {
        DetailsView()
            .environment(PortfolioViewModel())
            .environment(DetailsViewModel())
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
