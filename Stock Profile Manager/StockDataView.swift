import SwiftUI
import Kingfisher

struct StockDataView: View {
    var symbol: String
    @Environment(PortfolioViewModel.self) var portfolioViewModel
    @Environment(DetailsViewModel.self) var viewModel
    @Environment(FavoritesViewModel.self) var favoritesViewModel
    @State private var showingDetailSheet = false
    @State private var selectedNewsItem: NewsItem?
    @State private var showingTradeSheet = false
    @State private var showBuySuccessSheet = false
    @State private var showSellSuccessSheet = false
    @State private var numberOfShares: String = ""
    @State private var allSharesSold: Bool = false
    @State private var shouldCloseToHome = false
    @State private var sellClosed = false
    @State private var isFavorite: Bool = false
    
    var body: some View {
            //        NavigationView {
        ScrollView {
            ZStack{
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        Spacer()
                        ProgressView("Fetching Data...")
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                }  else {
                    VStack(alignment: .leading){
                        stockInfoSection
                        portfolioInfoSection
                        statsView
                        companyInfoView
                        insightsView
                        newsSection
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
            .sheet(isPresented: $showingDetailSheet, onDismiss: clearSelection) {
                    //                if let selectedNewsItem = selectedNewsItem {
                NewsDetailSheet(selectedNewsItem: self.$selectedNewsItem)
                    //                }
                    //                } else {
                    //                    Text("No News Item Selected")
                    //                }
            }
        }
        .onAppear {
            viewModel.searchString = symbol
            isFavorite = favoritesViewModel.favoritesEntries.contains { $0.symbol == symbol }
        }
        .onChange(of: favoritesViewModel.favoritesEntries) { _ in
            isFavorite = favoritesViewModel.favoritesEntries.contains { $0.symbol == symbol }
        }
        .navigationBarItems(trailing: favoriteButton)
    }
        //    }
    
    private var stockInfoSection: some View {
        VStack(alignment: .leading) {
            if let ticker = viewModel.companyInfo?.ticker {
                Text(ticker)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                    //                Spacer()
                Text(viewModel.companyInfo?.name ?? "")
                    .foregroundColor(.gray)
                    //                Spacer()
                PriceChangeView(priceDetails: viewModel.stockPriceDetails)
            }
        }
    }
    
    private var portfolioInfoSection: some View {
        Group {
            if let portfolioRecord = portfolioViewModel.portfolioRecordsData.first(where: { $0.stocksymbol == symbol }) {
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
                        showingTradeSheet = true
                    }) {
                        Text("Trade")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(20)
                    }
                    .sheet(isPresented: $showingTradeSheet) {
                        let portfolioRecord = portfolioViewModel.portfolioRecordsData.first(where: { $0.stocksymbol == symbol })
                        TradeSheetView(
                            numberOfShares: $numberOfShares,
                            availableFunds: portfolioViewModel.walletMoney ,
                            companyName:(viewModel.companyInfo?.name)!,
                            pricePerShare: (viewModel.stockPriceDetails?.c)!,
                            ownedShares: portfolioRecord!.quantity,
                            companyDetails: viewModel.companyInfo!,
                            showingTradeSheet: $showingTradeSheet,
                            showSellSuccessSheet: $showSellSuccessSheet,
                            showBuySuccessSheet: $showBuySuccessSheet,
                            allSharesSold: $allSharesSold
                        )
                    }
                    
                    .sheet(isPresented: $showBuySuccessSheet) {
                        SuccessBuySheet(sharesBought: $numberOfShares, companyName:(viewModel.companyInfo?.name)! , showBuySuccessSheet: $showBuySuccessSheet, showingTradeSheet: $showingTradeSheet)
                    }
                    
                    .sheet(isPresented: $showSellSuccessSheet) {
                        SuccessSellSheet(sharesSold: $numberOfShares, companyName:(viewModel.companyInfo?.name)! , showSellSuccessSheet: $showSellSuccessSheet, showingTradeSheet: $showingTradeSheet,
                                         allSharesSold: $allSharesSold,
                                         closeToHome: { val in
                            self.shouldCloseToHome = val
                        },
                                         sellClosed: $sellClosed)
                    }
                }
            } else {
                HStack{
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Portfolio")
                            .bold()
                            .font(.title)
                        Text("You have 0 shares of \(viewModel.companyInfo?.ticker ?? "").")
                        Text("Start trading!")
                    }
                    Button(action: {
                        showingTradeSheet = true
                    }) {
                        Text("Trade")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(20)
                    }.sheet(isPresented: $showingTradeSheet) {
                        TradeSheetView(
                            numberOfShares: $numberOfShares,
                            availableFunds: portfolioViewModel.walletMoney ,
                            companyName:(viewModel.companyInfo?.name)!,
                            pricePerShare: (viewModel.stockPriceDetails?.c)!,
                            ownedShares: 0,
                            companyDetails: viewModel.companyInfo!,
                            showingTradeSheet: $showingTradeSheet,
                            showSellSuccessSheet: $showSellSuccessSheet,
                            showBuySuccessSheet: $showBuySuccessSheet,
                            allSharesSold: $allSharesSold
                        )
                        
                    }
                    
                }
            }
        }
    }
    
    private var statsView: some View {
        StatsView(stockDetails: viewModel.stockPriceDetails)
    }
    
    private var insightsView: some View {
        InsightsView(symbol: symbol)
    }
    
    private var companyInfoView: some View {
        CompanyInfoView(company: viewModel.companyInfo)
    }
    
    private var newsSection: some View {
        NewsSection(news: viewModel.news!, showingDetailSheet: $showingDetailSheet, selectedNewsItem: $selectedNewsItem)
    }
    
    private var favoriteButton: some View {
        Button(action: toggleFavorite) {
            Image(systemName: isFavorite ? "plus.circle.fill" : "plus.circle")
                .imageScale(.large)
                .foregroundColor(.blue)
        }
    }
    
    private func toggleFavorite() {
        isFavorite.toggle()
        if isFavorite {
            favoritesViewModel.addToFavorites(symbol: symbol)
        } else {
            favoritesViewModel.removeFromFavorites(symbol: symbol)
        }
    }
    
    private func clearSelection() {
        selectedNewsItem = nil
    }
}

struct PriceChangeView: View {
    let priceDetails: StockPriceDetails?
    
    var body: some View {
        HStack(spacing: 2) {
            Text("$\(priceDetails?.c ?? 0, specifier: "%.2f")").bold().font(.title)
            if let change = priceDetails?.d, change != 0 {
                Image(systemName: change > 0 ? "arrow.up.forward" : "arrow.down.forward")
                    .foregroundColor(change > 0 ? .green : .red)
                    .padding(.trailing, 6)
            }
            Text("$\(priceDetails?.d ?? 0, specifier: "%.2f") (\(priceDetails?.dp ?? 0, specifier: "%.2f")%)")
                .foregroundColor(priceDetails?.d == 0 ? .black : (priceDetails?.d ?? 0 > 0 ? .green : .red))
        }
        .font(.system(size: 16))
    }
}

struct PortfolioInfoView: View {
    let portfolioRecord: PortfolioRecord
    @Binding var showingTradeSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Portfolio Details:")
                .font(.headline)
            Text("Shares Owned: \(portfolioRecord.quantity, specifier: "%.0f")")
            Text("Average Cost Per Share: $\(portfolioRecord.cost / portfolioRecord.quantity, specifier: "%.2f")")
            Text("Total Cost: $\(portfolioRecord.cost, specifier: "%.2f")")
            Button("Trade") {
                showingTradeSheet = true
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(20)
        }
    }
}

struct StatsView: View {
    let stockDetails: StockPriceDetails?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Stats")
                .bold()
                .font(.title2)
            HStack{
                VStack{
                    HStack{
                        Text("High Price: ")
                            .bold()
                        Text("$\(stockDetails?.h ?? 0, specifier: "%.2f")")
                    }
                    HStack{
                        Text("Low Price: ")
                            .bold()
                        Text("$\(stockDetails?.l ?? 0, specifier: "%.2f")")
                    }
                    
                }
                VStack{
                    HStack{
                        Text("Open Price: ")
                            .bold()
                        Text("$\(stockDetails?.o ?? 0, specifier: "%.2f")")
                    }
                    
                    HStack{
                        Text("Prev. Close: ")
                            .bold()
                        Text("$\(stockDetails?.c ?? 0, specifier: "%.2f")")
                    }
                }
            }
        }
    }
}

struct InsightsView: View {
    let symbol: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("Insights")
                .bold()
                .font(.title2)
            RecommendationTrendsView(ticker: symbol)
                .frame(height: 400)
            EPSSurpriseView(ticker: symbol)
                .frame(height: 400)
        }
    }
}

struct CompanyInfoView: View {
    let company: Details?
    @Environment(DetailsViewModel.self) var viewModel
    var body: some View {
        VStack(alignment: .leading) {
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
                            NavigationLink(destination: StockDataView(symbol: peer)
                                .environment(viewModel)
                            ) {
                                Text(peer)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct NewsSection: View {
    let news: [NewsItem]
        //    let item: NewsItem
    @Binding var showingDetailSheet: Bool
    @Binding var selectedNewsItem: NewsItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("News")
                .bold()
                .font(.title2)
            
                // First news item
            if let firstItem = news.first {
                    // Render the first item as a larger view
                NewsItemView(newsItem: firstItem, isLarge: true, showingDetailSheet: $showingDetailSheet, selectedNewsItem: $selectedNewsItem)
                
                    // Render remaining items
                ForEach(news.dropFirst(), id: \.id) { newsItem in
                    NewsItemView(newsItem: newsItem, isLarge: false, showingDetailSheet: $showingDetailSheet, selectedNewsItem: $selectedNewsItem)
                }
            } else {
                    // Display a message if no news is available
                Text("No news available.")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
    }
}

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

