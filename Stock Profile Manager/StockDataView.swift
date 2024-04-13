    //
    //  StockDataView.swift
    //  Stock Profile Manager
    //
    //  Created by Mansi Garg on 4/9/24.
    //

import SwiftUI
import Kingfisher

struct StockDataView: View {
    
    var symbol: String
    @ObservedObject var viewModel = DetailsViewModel()
    @StateObject private var portfolioViewModel = PortfolioViewModel()
    @State private var showingDetailSheet = false
    @State private var selectedNewsItem: NewsItem?
    @State private var showingTradeSheet = false
    
    var body: some View {
        ScrollView {
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
                                        showingTradeSheet = true // Toggle the state to show the trade sheet
//                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Trade")
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.green)
                                            .cornerRadius(20)
                                    }
                                    .sheet(isPresented: $showingTradeSheet) {
                                        TradeSheetView() // Pass the required parameters to your trade sheet view
                                    }
                                }
                            } else {
                                HStack{
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Portfolio")
                                            .bold()
                                            .font(.title)
                                        Text("You have 0 shares of \(viewModel.companyInfo?.ticker).")
                                        Text("Start trading!")
                                    }
                                    Button(action: {
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
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if let news = viewModel.news, !news.isEmpty {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("News")
                                        .bold()
                                        .font(.title2)
                                    
                                        // First news item
                                    NewsItemView(newsItem: news[0], isLarge: true, showingDetailSheet: $showingDetailSheet,selectedNewsItem: $selectedNewsItem)
                                    
                                        // Remaining news items
                                    ForEach(news.dropFirst(), id: \.id) { newsItem in
                                        NewsItemView(newsItem: newsItem, isLarge: false,showingDetailSheet: $showingDetailSheet,  selectedNewsItem: $selectedNewsItem)
                                    }
                                }
                            }
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
                    
                }
            }
            .sheet(isPresented: $showingDetailSheet, onDismiss: clearSelection) {
                if let selectedNewsItem = selectedNewsItem {
                    NewsDetailSheet(newsItem: selectedNewsItem)
                } else {
                    Text("No News Item Selected")
                }
            }
            
                // zstack endedd
        } // scroll view ened
        .onAppear {
            viewModel.searchString = symbol
        }
    } // view ended
    private func clearSelection() {
        selectedNewsItem = nil  // Clear the selection when the sheet is dismissed
    }
} // struct ended

//struct NewsItemView: View {
//    let newsItem: NewsItem
//    let isLarge: Bool
//    @Binding var showingDetailSheet: Bool
//    @Binding var selectedNewsItem: NewsItem?
//    
//    var body: some View {
//        Button(action: {
//                // Set the selected news item and show the detail sheet when the button is tapped
//            self.selectedNewsItem = newsItem
//            self.showingDetailSheet = true
//        }) {
//                // The content of the button is the same view you had before
//            if isLarge {
//                LargeNewsItemView(newsItem: newsItem, action: {
//                    self.selectedNewsItem = newsItem
//                    self.showingDetailSheet = true}
//                )
//                
//            } else {
//                SmallNewsItemView(newsItem: newsItem, action: {
//                    self.selectedNewsItem = newsItem
//                    self.showingDetailSheet = true})
//            }
//            
//        }
//            // Customize button to look like a regular view
//        .buttonStyle(PlainButtonStyle())
//    }
//}
struct NewsItemView: View {
    let newsItem: NewsItem
    let isLarge: Bool
    @Binding var showingDetailSheet: Bool
    @Binding var selectedNewsItem: NewsItem?
    
    var body: some View {
        Button(action: {
            DispatchQueue.main.async {
                self.selectedNewsItem = newsItem  // Directly assigning the newsItem to selectedNewsItem
                self.showingDetailSheet = true
            }
        }) {
                // The content of the button is the same view you had before
            if isLarge {
                LargeNewsItemView(newsItem: newsItem, action: {
                    self.selectedNewsItem = newsItem
                    self.showingDetailSheet = true}
                )
                
            } else {
                SmallNewsItemView(newsItem: newsItem, action: {
                    self.selectedNewsItem = newsItem
                    self.showingDetailSheet = true})
            }
            
        }
            // Customize button to look like a regular view
        .buttonStyle(PlainButtonStyle())
    }
}


//struct LargeNewsItemView: View {
//    let newsItem: NewsItem
//    var action: () -> Void
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            KFImage(URL(string: newsItem.image!))
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .clipped()
//            HStack {
//                
//                Text(newsItem.source!)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                Text(Utils.relativeTimeString(from: newsItem.datetime!))
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                
//            }
//            Text(newsItem.headline!)
//                .font(.headline)
//                .lineLimit(3)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(8)
//        .shadow(radius: 4)
//        .onTapGesture(perform: action)
//    }
//}

//struct SmallNewsItemView: View {
//    let newsItem: NewsItem
//    var action: () -> Void
//    var body: some View {
//        HStack {
//            
//            VStack(alignment: .leading) {
//                HStack{
//                    
//                    Text(newsItem.source!)
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                    Text(Utils.relativeTimeString(from: newsItem.datetime!))
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                    
//                }
//                Text(newsItem.headline!)
//                    .font(.headline)
//                .lineLimit(2)            }
//            .padding(.leading, 5)
//            
//            KFImage(URL(string: newsItem.image!))
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 80, height: 80)
//                .clipped()
//                .cornerRadius(8)
//        }
//        .background(Color.white)
//        .cornerRadius(8)
//        .shadow(radius: 4)
//    }
//}
struct LargeNewsItemView: View {
    let newsItem: NewsItem
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            KFImage(URL(string: newsItem.image!))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
            HStack {
                Text(newsItem.source!)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(Utils.relativeTimeString(from: newsItem.datetime!))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(newsItem.headline!)
                .font(.headline)
                .lineLimit(3)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .onTapGesture {
            action()
        }
    }
}


struct SmallNewsItemView: View {
    let newsItem: NewsItem
    var action: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack{
                    Text(newsItem.source!)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(Utils.relativeTimeString(from: newsItem.datetime!))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(newsItem.headline!)
                    .font(.headline)
                    .lineLimit(2)
            }
            .padding(.leading, 5)
            KFImage(URL(string: newsItem.image!))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(8)
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .onTapGesture {
            action()
        }
    }
}



#Preview {
    StockDataView(symbol: "")
}
