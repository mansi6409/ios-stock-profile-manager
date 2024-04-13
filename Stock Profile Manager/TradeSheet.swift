import SwiftUI

struct TradeSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var numberOfShares: String = ""
    @State  var availableFunds: Double// Replace with actual funds value
    //var availableFunds: Double // This will be passed when initiating the sheet
    @State  var companyName: String // The company name to trade
    @State  var pricePerShare: Double // The price per share
    var calculatedTotal: Double {
        if let numberOfSharesDouble = Double(numberOfShares) {
            return numberOfSharesDouble * pricePerShare
        } else {
            return 0
        }
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
                }
                
//                Spacer()
                
                Text("Trade Apple Inc shares")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                HStack {
                        // Number of Shares Text Field
                    TextField("0", text: $numberOfShares)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 52)) // Increased font size
                        .multilineTextAlignment(.leading)
                        .frame(height: 400) // Adjust height to fit the text
//                        .padding(.trailing, 12)
                        .padding(.bottom, 65)
                    
                    Spacer() // Pushes the text field to the left and other content to the right
                    
                        // Shares Label and Total Cost Calculation
                    VStack(alignment: .trailing) {
                            // Share or Shares text
                        Text("\(Int(numberOfShares) ?? 0 <= 1 ? "Share" : "Shares")")
                            .font(.system(size: 32)) // Adjust font size
                            .padding(.top, 2) // Slight adjustment to align with the text field
                        
                        Text("× $\(pricePerShare, specifier: "%.2f")/share = $\(calculatedTotal, specifier: "%.2f")")
                            .font(.system(size: 16)) // Matching font size with "Shares" text
                            .padding(.top, 4) // Adjust padding to ensure proper vertical spacing
                    
                    }
                }
                
                Spacer()
                
                Text("$\(availableFunds, specifier: "%.2f") available to buy AAPL")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button("Buy") {
                            // Handle buy action
                    }
                    .buttonStyle(FilledButtonStyle())
                    
                    Button("Sell") {
                            // Handle sell action
                    }
                    .buttonStyle(FilledButtonStyle())
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
    }
}

struct TradeSheetView_Previews: PreviewProvider {
    static var previews: some View {
        TradeSheetView(availableFunds: 0, companyName: "", pricePerShare: 0)
    }
}
