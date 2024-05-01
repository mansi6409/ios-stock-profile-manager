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
    @State private var showHourly = true
    
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    
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
                        chartsView
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
        .toast(isPresented: $showToast, message: toastMessage)
    }
        //    }
    
    private var stockInfoSection: some View {
        VStack(alignment: .leading) {
            if let ticker = viewModel.companyInfo?.ticker {
                Text(ticker)
                    .font(.system(size: 28))
                    .bold()
                    .foregroundColor(.primary)
                    //                Spacer()
                HStack {
                    Text(viewModel.companyInfo?.name ?? "")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    if let logoURLString = viewModel.companyInfo?.logo, let logoURL = URL(string: logoURLString) {
                            // Assuming you are using Kingfisher to handle URL-based images
                        KFImage(logoURL)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)  // Set appropriate size for the logo
                            .clipped()
                            .cornerRadius(10)  // Round the corners with a radius of 10
                            .padding(.trailing, 20)
                    }
                    
                }
                    //                Spacer()
                PriceChangeView(priceDetails: viewModel.stockPriceDetails)
            }
        }
        .padding()
    }
    
    private var portfolioInfoSection: some View {
        Group {
            if let portfolioRecord = portfolioViewModel.portfolioRecordsData.first(where: { $0.stocksymbol == symbol }) {
                HStack{
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Portfolio")
//                            .bold()
                            .font(.system(size: 24))
                            .padding(.bottom, 8)
                        HStack {
                            Text("Shares Owned: ")
                                .bold()
                            Text("\(portfolioRecord.quantity, specifier: "%.0f")")
                        }
                        .padding(.bottom, 8)
                        .font(.subheadline)

                        HStack {
                            Text("Avg. Cost/Share: ")
                                .bold()
                            Text("$\(portfolioRecord.cost / portfolioRecord.quantity, specifier: "%.2f")")
                        }
                        .padding(.bottom, 8)
                        .font(.subheadline)

                        HStack {
                            Text("Total Cost: ")
                                .bold()
                            Text("$\(portfolioRecord.cost, specifier: "%.2f")")
                        }
                        .padding(.bottom, 8)
                        .font(.subheadline)

                        HStack {
                            Text("Change: ")
                                .bold()
                            + Text("\(portfolioRecord.change?.formatted(.currency(code: "USD")) ?? "-")")
                                .foregroundColor(
                                    portfolioRecord.change ?? 0 > 0 ? .green :
                                        portfolioRecord.change ?? 0 < 0 ? .red : .black
                                )
                        }
                        .padding(.bottom, 8)
                        .font(.subheadline)

                        HStack {
                            Text("Market Value: ")
                                .bold()
                            + Text("$\(portfolioRecord.totalValue ?? 0, specifier: "%.2f")")
                                .foregroundColor(
                                    portfolioRecord.change ?? 0 > 0 ? .green :
                                        portfolioRecord.change ?? 0 < 0 ? .red : .black
                                )
                        }
                        .padding(.bottom, 8)
                        .font(.subheadline)

                    }
                    .frame(width: UIScreen.main.bounds.width*0.6)
                    VStack {
                        Button("Trade"){
                            showingTradeSheet = true
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(20)
                        .clipShape(Capsule())
                        .frame(width: UIScreen.main.bounds.width*0.35)
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
                    .frame(width: UIScreen.main.bounds.width*0.4)
                }
            } else {
                HStack{
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Portfolio")
                            .font(.system(size: 24))
                            .padding(.bottom, 8)
                        Text("You have 0 shares of \(viewModel.companyInfo?.ticker ?? "").")
                        Text("Start trading!")
                    }
                    .frame(width: UIScreen.main.bounds.width*0.6)
                    VStack{
                        Button("Trade"){
                            showingTradeSheet = true
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(20)
                        .clipShape(Capsule())
                        .frame(width: UIScreen.main.bounds.width*0.35)
                        .sheet(isPresented: $showingTradeSheet) {
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
                    .frame(width: UIScreen.main.bounds.width*0.4)
                }
            }
        }
    }
    
    private var chartsView: some View {
        HStack {
            VStack {
                HStack {
                    if (showHourly) {
                        let color = ((viewModel.stockPriceDetails?.d ?? 0) > 0 ? "green" : ((viewModel.stockPriceDetails?.d ?? 0) < 0 ? "red" : "gray"))
                        HourlyView(ticker: symbol, color: color)
                            .frame(height: 410)
                    }
                    else {
                        HistoricalChartView(ticker: symbol)
                            .frame(height: 410)
                    }
                }
                Divider()
                HStack {
                    Spacer()
                    Button(action: {
                        showHourly = true
                    }) {
                        VStack {
                            Image(systemName: "chart.xyaxis.line")
                                .font(.title2)
                            Text ("Hourly")
                                .font(.caption2)
                        }
                    }
                    .foregroundColor(showHourly ? .blue : .gray)
                    .padding()
                    Spacer()
                    Spacer()
                    Button(action: {
                        showHourly = false
                    }) {
                        VStack {
                            Image(systemName: "clock.fill")
                                .font(.title2)
                            Text("Historical")
                                .font(.caption2)
                        }
                    }
                    .foregroundColor(showHourly ? .gray : .blue)
                    .padding()
                    Spacer()
                }
            }
        }
        .padding()
    }
    
    private var statsView: some View {
        StatsView(stockDetails: viewModel.stockPriceDetails)
    }
    
    private var insightsView: some View {
            VStack(alignment: .leading) {
                Text("Insights")
                    .font(.system(size: 24))
                    .padding(.bottom, 8)
                InsightsTableView(symbol: symbol, companyName: (viewModel.companyInfo?.name ?? ""))
//                    .frame(height: 400)
                RecommendationTrendsView(ticker: symbol)
                    .frame(height: 400)
                EPSSurpriseView(ticker: symbol)
                    .frame(height: 400)
            }
            .padding()
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
            showToast(message: "Adding \(symbol) to Favorites")
        } else {
            favoritesViewModel.removeFromFavorites(symbol: symbol)
            showToast(message: "Removing \(symbol) from Favorites")
        }
    }
    
    private func showToast(message: String) {
        toastMessage = message
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
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
            Text("$\(priceDetails?.c ?? 0, specifier: "%.2f")")
                .bold()
                .font(.system(size: 28))
            if let change = priceDetails?.d, change != 0 {
                Image(systemName: change > 0 ? "arrow.up.forward" : "arrow.down.forward")
                    .foregroundColor(change > 0 ? .green : .red)
                    .padding(.trailing, 6)
                    .font(.system(size: 24))
            }
            Text("$\(priceDetails?.d ?? 0, specifier: "%.2f") (\(priceDetails?.dp ?? 0, specifier: "%.2f")%)")
                .foregroundColor(priceDetails?.d == 0 ? .black : (priceDetails?.d ?? 0 > 0 ? .green : .red))
                .font(.system(size: 24))
        }
        .font(.system(size: 16))
    }
}

struct StatsView: View {
    let stockDetails: StockPriceDetails?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Stats")
                .font(.system(size: 24))
                .padding(.bottom, 8)
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
                .padding(.bottom, 14)
                .font(.subheadline)
                .padding(.trailing, 7)
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
                .font(.subheadline)
                .padding(.bottom, 14)
            }
        }
        .padding()
    }
}

struct CompanyInfoView: View {
    let company: Details?
    @Environment(DetailsViewModel.self) var viewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("About")
                .font(.system(size: 24))
                .padding(.bottom, 8)
            
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
        .padding()
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
                .font(.system(size: 24))
                .padding(.bottom, 8)
            
                // First news item
            if let firstItem = news.first {
                    // Render the first item as a larger view
                NewsItemView(newsItem: firstItem, isLarge: true, showingDetailSheet: $showingDetailSheet, selectedNewsItem: $selectedNewsItem)
                Divider()
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
        .padding()
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
                .cornerRadius(8)
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
//        .padding()
        .background(Color.white)
//        .shadow(radius: 4)
        .onTapGesture {
            action()
        }
        Divider()
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
//            .padding(.leading, 5)
            Spacer()
            KFImage(URL(string: newsItem.image!))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(8)
                .padding()
        }
        .background(Color.white)
        .cornerRadius(8)
//        .padding()
//        .shadow(radius: 4)
        .onTapGesture {
            action()
        }
    }
}

//struct ToastViewDetails: ViewModifier {
//    @Binding var isPresented: Bool
//    let message: String
//    
//    func body(content: Content) -> some View {
//        ZStack {
//            content
//            if isPresented {
//                Text(message)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.gray)
//                    .cornerRadius(30)
//                    .transition(.slide)
//                    // Style your toast here
//                    .onAppear {
//                            // Automatically dismiss the toast after 2 seconds
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            isPresented = false
//                        }
//                    }
//                    .zIndex(1)
//                    .padding(.top, 640)
//                    //                    .frame(width: 500)
//            }
//        }
//    }
//}

