import SwiftUI

struct TradeSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var numberOfShares: String
    @State  var availableFunds: Double// Replace with actual funds value
        //var availableFunds: Double // This will be passed when initiating the sheet
    @State  var companyName: String // The company name to trade
    @State  var pricePerShare: Double // The price per share
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State var ownedShares: Double
    @State private var toastMessage: String = ""
    @State private var showErrorToast: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @State var companyDetails: Details?
        //    @ObservedObject private var portfolioViewModel = PortfolioViewModel()
    @Environment(PortfolioViewModel.self) var portfolioViewModel
    @Binding var showingTradeSheet: Bool
    @Binding var showSellSuccessSheet: Bool
    @Binding var showBuySuccessSheet: Bool
    @Binding var allSharesSold: Bool
    
    var calculatedTotal: Double {
        if let numberOfSharesDouble = Double(numberOfShares) {
            return numberOfSharesDouble * pricePerShare
        } else {
            return 0
        }
    }
    private func executeTrade(action: TradeAction) {
        guard let shares = Int(numberOfShares) else {
                // The input is not a valid integer number
            showError(with: "Please enter a valid amount")
            return
        }
        
        if shares <= 0 {
                // The input is not positive
            let error = action == .buy ? "Cannot buy non-positive shares" : "Cannot sell non-positive shares"
            showError(with: error)
            return
        }
        switch action {
            case .buy:
                if calculatedTotal > availableFunds {
                    showError(with: "Not enough money to buy")
                } else {
                    if let ticker = companyDetails?.ticker,
                       let shares = Double(numberOfShares){
                        if (ownedShares == 0){
                            portfolioViewModel.addPortfolioRecord(symbol: ticker, quantity: shares, price: calculatedTotal)
                            portfolioViewModel.updateWalletMoney(amount: -calculatedTotal)
                            showingTradeSheet = false
                            showBuySuccessSheet = true
                                //                            portfolioViewModel.refreshData()
                        } else {
                            portfolioViewModel.updatePortfolioRecord(symbol: ticker, quantity: (ownedShares + shares), price: calculatedTotal)
                            portfolioViewModel.updateWalletMoney(amount: -calculatedTotal)
                            showingTradeSheet = false
                            showBuySuccessSheet = true
                                //                            portfolioViewModel.refreshData()
                        }
                    }
                }
            case .sell:
                if let sharesToSell = Double(numberOfShares), sharesToSell > ownedShares{
                    showError(with: "Not enough shares to sell")
                } else {
                    if let ticker = companyDetails?.ticker,
                       let shares = Double(numberOfShares){
                        if (Double(ownedShares) == Double(numberOfShares)){
                            portfolioViewModel.removePortfolioRecord(symbol: ticker)
                            portfolioViewModel.updateWalletMoney(amount: calculatedTotal)
                            showingTradeSheet = false
                            showSellSuccessSheet = true
                            allSharesSold = true
                        } else {
                            portfolioViewModel.updatePortfolioRecord(symbol: ticker, quantity: (ownedShares - shares), price: calculatedTotal)
                            portfolioViewModel.updateWalletMoney(amount: -calculatedTotal)
                            showingTradeSheet = false
                            showSellSuccessSheet = true
                            allSharesSold = false
                        }
                    }
                }
        }
            //        showErrorToast = !toastMessage.isEmpty
        
    }
    
    private func showError(with message: String) {
        toastMessage = message
        showErrorToast = true
    }
    
    enum TradeAction {
        case buy, sell
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                            .padding()
                    }
                    .foregroundColor(.secondary)
                }
                Text("Trade \(companyName) shares")
                    .font(.system(size: 20))
                    //                    .bold()
                Spacer()
                HStack {
                        // Number of Shares Text Field
                    TextField("0", text: $numberOfShares)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 122)) // Increased font size
                        .multilineTextAlignment(.leading)
                        .frame(height: 400) // Adjust height to fit the text
                        //                        .padding(.trailing, 12)
                        .padding(.bottom, 65)
                    
                    Spacer() // Pushes the text field to the left and other content to the right
                    
                        // Shares Label and Total Cost Calculation
                    VStack(alignment: .trailing) {
                            // Share or Shares text
                        Text("\(Int(numberOfShares) ?? 0 <= 1 ? "Share" : "Shares")")
                            .font(.system(size: 32)) // Adjust font size44
                            .padding(.top, 55) // Slight adjustment to align with the text field
                        
                        Text("× $\(pricePerShare, specifier: "%.2f")/share = $\(calculatedTotal, specifier: "%.2f")")
                            .font(.system(size: 15))
                            .padding(.top, 4)
                            .padding(.trailing, 4)
                    }
                }
                Spacer()
                Text("$\(availableFunds, specifier: "%.2f") available to buy AAPL")
                    .foregroundColor(.secondary)
                Spacer()
                HStack(/*spacing: 20*/) {
                    Button("Buy") {
                        executeTrade(action: .buy)
                    }
                    .foregroundColor(.white)
                        //                    .padding()
                    .background(Color.green)
                    .cornerRadius(30)
                    .frame(width: UIScreen.main.bounds.width * 0.2)
                    .buttonStyle(FilledButtonStyle())
                    Spacer()
                    Button("Sell") {
                        executeTrade(action: .sell)
                        
                    }
                    .foregroundColor(.white)
                        //                    .padding()
                    .background(Color.green)
                    .cornerRadius(30)
                    .frame(width: UIScreen.main.bounds.width * 0.2)
                    .buttonStyle(FilledButtonStyle())
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
                    //                .frame(maxWidth: .infinity)
                    //                .alert(isPresented: $showError) {
                    //                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                    //                }
            }
            .padding()
            .navigationBarHidden(true)
            .toast(isPresented: $showErrorToast, message: toastMessage)
//            .sheet(isPresented: $showBuySuccessSheet) {
//                SuccessBuySheet(sharesBought: $numberOfShares, companyName: companyName, showBuySuccessSheet: $showBuySuccessSheet, showingTradeSheet: $showingTradeSheet)
//            }
//            .sheet(isPresented: $showSellSuccessSheet){
//                SuccessSellSheet(sharesSold: $numberOfShares, companyName: companyName, showSellSuccessSheet: $showSellSuccessSheet, showingTradeSheet: $showingTradeSheet)
//            }
                //            .padding(.bottom, keyboardHeight) // Use the keyboard height to adjust padding
                //            .onAppear {
                //                NotificationCenter.default.addObserver(
                //                    forName: UIResponder.keyboardWillShowNotification,
                //                    object: nil,
                //                    queue: .main
                //                ) { notification in
                //                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                //                        keyboardHeight = keyboardSize.height
                //                    }
                //                }
                //
                //                NotificationCenter.default.addObserver(
                //                    forName: UIResponder.keyboardWillHideNotification,
                //                    object: nil,
                //                    queue: .main
                //                ) { _ in
                //                    keyboardHeight = 0
                //                }
                //            }
                //            .onDisappear {
                //                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                //                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                //            }
        }
        .onDisappear {
                // Reset the number of shares when the view disappears
            numberOfShares = ""
        }
        .padding()
        
        
    }
}


struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(30)
            //            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .frame(width: UIScreen.main.bounds.width * 0.4)
        
            //            .frame(maxWidth: .infinity)
    }
}

#Preview {
    TradeSheetView(numberOfShares: .constant(""),availableFunds: 0,  companyName: "", pricePerShare: 0, ownedShares: 0, showingTradeSheet: .constant(true), showSellSuccessSheet: .constant(true), showBuySuccessSheet: .constant(true), allSharesSold: .constant(false))
        .environment(PortfolioViewModel())
}

extension View {
    func equalSizes() -> some View {
        self.modifier(EqualSizesModifier())
    }
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastView(isPresented: isPresented, message: message))
    }
}

struct ToastView: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Text(message)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(30)
                    .transition(.slide)
                    // Style your toast here
                    .onAppear {
                            // Automatically dismiss the toast after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isPresented = false
                        }
                    }
                    .zIndex(1)
                    .padding(.top, 640)
                    //                    .frame(width: 500)
            }
        }
    }
}


struct EqualSizesModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
        }
        .frame(maxWidth: .infinity)
    }
}


