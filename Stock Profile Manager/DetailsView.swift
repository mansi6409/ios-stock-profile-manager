//
//  DetailsView.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/6/24.
//

import SwiftUI

struct DetailsView: View {
    @ObservedObject var viewModel = DetailsViewModel()
    @StateObject private var portfolioViewModel = PortfolioViewModel()

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
            Text("\(viewModel.stockPriceDetails?.c ?? 0.0)")
                .padding(.top, 10)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
//            Spacer()
//            Text("Ticker: \(viewModel.companyInfo?.ticker ?? "0.0")")
//                .padding(.top, 10)
//                .padding(.horizontal, 10)
//                .padding(.bottom, 10)
            Section(header: Text("PORTFOLIO")) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Net Worth")
                            .font(.headline)
                        Text("$\(portfolioViewModel.walletMoney, specifier: "%.2f")")
                            .font(.title)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Cash Balance")
                            .font(.headline)
                        Text("$\(25000, specifier: "%.2f")")
                            .font(.title)
                    }
                }
                .padding()
//                ForEach(portfolioItems) { item in
//                    HStack {
//                        Text(item.symbol)
//                        Spacer()
//                        Text("$\(item.currentValue, specifier: "%.2f")")
//                        Text("\(item.change > 0 ? "▲" : "▼") $\(item.change, specifier: "%.2f") (\(item.changePercentage, specifier: "%.2f")%)")
//                            .foregroundColor(item.change > 0 ? .green : .red)
//                    }
//                }
            }
            
            Section(header: Text("FAVORITES")) {
//                ForEach(favoriteItems) { item in
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text(item.name)
//                            Text(item.symbol)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                        Spacer()
//                        Text("$\(item.currentPrice, specifier: "%.2f")")
//                        Text("\(item.change > 0 ? "▲" : "▼") $\(item.change, specifier: "%.2f") (\(item.changePercentage, specifier: "%.2f")%)")
//                            .foregroundColor(item.change > 0 ? .green : .red)
//                    }
//                }
            }


        }.background(Color(.systemGroupedBackground))
    }
    
    func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: Date())
    }
}

//#Preview {
//    DetailsView(viewModel: <#DetailsViewModel#>)
//}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(viewModel: DetailsViewModel())
    }
}
