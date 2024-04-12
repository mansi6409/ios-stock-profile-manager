    //
    //  StockDataView.swift
    //  Stock Profile Manager
    //
    //  Created by Mansi Garg on 4/9/24.
    //

import SwiftUI

struct StockDataView: View {
    
    var symbol: String
    @ObservedObject var viewModel = DetailsViewModel()
    @ObservedObject private var portfolioViewModel = PortfolioViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isLoading == true{
                ProgressView("Loading...")
            }
            else {
                
                VStack(alignment: .leading) {
                    if let ticker = viewModel.companyInfo?.ticker, let name = viewModel.companyInfo?.name {
                        
                        Text((viewModel.companyInfo?.ticker) ?? "")
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)
                        Text((viewModel.companyInfo?.name) ?? "")
                            .foregroundColor(.gray)
                        HStack(spacing: 2) {
                            Text("$\((viewModel.stockPriceDetails?.c ?? 0), specifier: "%.2f")")
                                .bold()
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            if let change = viewModel.stockPriceDetails?.d, change != 0 {
                                Image(systemName: change > 0 ? "arrow.up.forward" : "arrow.down.forward")
                                    .foregroundColor(change > 0 ? .green : .red)
                                    .padding(.trailing, 6)
                            }
                            Text("$\(viewModel.stockPriceDetails?.d ?? 0, specifier: "%.2f") (\(viewModel.stockPriceDetails?.dp ?? 0, specifier: "%.2f")%)")
                                .foregroundColor(viewModel.stockPriceDetails?.d == 0 ? .black : (viewModel.stockPriceDetails?.d ?? 0 > 0 ? .green : .red))
                        }
                        .font(.system(size: 16))
                        
                            //                TabView {
                            //                    HighchartsView(chartType: "hourly", symbol: viewModel.companyInfo?.ticker)
                            //                        .tabItem {
                            //                            Image(systemName: "chart.xyaxis.line")
                            //                            Text("Hourly")
                            //                        }
                            //
                            //                    HighchartsView(chartType: "historical", symbol: viewModel.companyInfo?.ticker) // Adjust the options for historical view
                            //                        .tabItem {
                            //                            Image(systemName: "clock")
                            //                            Text("Historical")
                            //                        }
                            //                }
                        if let portfolioRecord = portfolioViewModel.portfolioRecordsData.first(where: { $0.stocksymbol == symbol }) {
                                // When stocks are owned
                            HStack{
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Portfolio")
                                        .bold()
                                        .font(.title)
                                    HStack {
                                        Text("Shares Owned: ")
                                            .bold()
                                        Text("\(portfolioRecord.quantity, specifier: "%.0f")")
                                    }
                                    HStack {
                                        Text("Avg. Cost / Share: ")
                                            .bold()
                                        Text("$\(portfolioRecord.cost / portfolioRecord.quantity, specifier: "%.2f")")
                                    }
                                    HStack {
                                        Text("Total Cost: ")
                                            .bold()
                                        Text("$\(portfolioRecord.cost, specifier: "%.2f")")
                                    }
                                    HStack {
                                        Text("Change: ")
                                            .bold()
                                        + Text("\(portfolioRecord.change?.formatted(.currency(code: "USD")) ?? "-")")
                                            .foregroundColor(
                                                portfolioRecord.change ?? 0 > 0 ? .green :
                                                    portfolioRecord.change ?? 0 < 0 ? .red : .black
                                            )
                                    }
                                    HStack {
                                        Text("Market Value: ")
                                            .bold()
                                        + Text("$\(portfolioRecord.totalValue ?? 0, specifier: "%.2f")")
                                            .foregroundColor(
                                                portfolioRecord.change ?? 0 > 0 ? .green :
                                                    portfolioRecord.change ?? 0 < 0 ? .red : .black
                                            )
                                    }
                                }
                                Button(action: {
                                        // Trigger trade action
                                }) {
                                    Text("Trade")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.green)
                                        .cornerRadius(20)
                                }
                            }
                        } else {
                                // When no stocks are owned
                            HStack{
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Portfolio")
                                        .bold()
                                        .font(.title)
                                    Text("You have 0 shares of \(viewModel.companyInfo?.ticker).")
                                    Text("Start trading!")
                                }
                                Button(action: {
                                        // Trigger trade action
                                }) {
                                    Text("Trade")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.green)
                                        .cornerRadius(20)
                                }
                                
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Stats")
                                .bold()
                                .font(.title2)
                            
                            HStack{
                                VStack{
                                    HStack{
                                        Text("High Price: ")
                                            .bold()
                                        Text("$\(viewModel.stockPriceDetails?.h ?? 0, specifier: "%.2f")")
                                    }
                                    HStack{
                                        Text("Low Price: ")
                                            .bold()
                                        Text("$\(viewModel.stockPriceDetails?.l ?? 0, specifier: "%.2f")")
                                    }
                                    
                                }
                                VStack{
                                    HStack{
                                        Text("Open Price: ")
                                            .bold()
                                        Text("$\(viewModel.stockPriceDetails?.o ?? 0, specifier: "%.2f")")
                                    }
                                    
                                    HStack{
                                        Text("Prev. Close: ")
                                            .bold()
                                        Text("$\(viewModel.stockPriceDetails?.c ?? 0, specifier: "%.2f")")
                                    }
                                }
                            }
                        }
                            //                .padding()
                            //                .background(Color.white)
                            //                .cornerRadius(10)
                            //                .shadow(radius: 5)
                        
                            // About Section
                        VStack(alignment: .leading, spacing: 5) {
                            Text("About")
                                .bold()
                                .font(.title2)
                            
                            HStack {
                                Text("IPO Start Date: ")
                                    .bold()
                                Text(viewModel.companyInfo?.ipo ?? "N/A")
                            }
                            
                            HStack {
                                Text("Industry: ")
                                    .bold()
                                Text(viewModel.companyInfo?.finnhubIndustry ?? "N/A")
                            }
                            
                            HStack {
                                Text("Webpage: ")
                                    .bold()
                                if let urlString = viewModel.companyInfo?.weburl, let url = URL(string: urlString) {
                                    Link("\(viewModel.companyInfo?.weburl ?? "")", destination: url)
                                } else {
                                    Text("N/A")
                                }
                            }
                            
                            HStack {
                                Text("Company Peers: ")
                                    .bold()
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(viewModel.companyInfo?.peers ?? [], id: \.self) { peer in
                                            NavigationLink(destination: StockDataView(symbol: peer)) {
                                                Text(peer)
                                                    .foregroundColor(.blue)
                                                    //                                            .padding(5)
                                                    //                                            .overlay(
                                                    //                                                RoundedRectangle(cornerRadius: 5)
                                                    //                                                    .stroke(Color.blue, lineWidth: 1)
                                                    //                                            )
                                            }
                                        }
                                    }
                                }
                                    //                        Text(viewModel.companyInfo?.peers?.joined(separator: ", ") ?? "N/A")
                            }
                        }
                            //                .padding()
                            //                .background(Color.white)
                            //                .cornerRadius(10)
                            //                .shadow(radius: 5)
                            //            .padding()
                            //            .background(Color.white)
                            //            .cornerRadius(10)
                            //            .shadow(radius: 5)
                    }
                    
                    
                    else {
                        ZStack {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 15)
                
                .onAppear {
                    viewModel.searchString = symbol
                }
            }
        }
    }
}
    
    #Preview {
        StockDataView(symbol: "")
    }
