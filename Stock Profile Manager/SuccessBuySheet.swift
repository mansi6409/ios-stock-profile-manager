//
//  SuccessBuySheet.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/13/24.
//

import SwiftUI

struct SuccessBuySheet: View {
    var numberOfShares: String
    @State var companyName: String
    @Binding var showBuySuccessSheet: Bool
    @Binding var showingTradeSheet: Bool

//    var onDone: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Text("Congratulations!")
                .font(.largeTitle)
                .bold()
            Text("You have successfully bought \(numberOfShares) \(Double(numberOfShares) == 1 ? "share" : "shares") of \(companyName)")
                .font(.title3)
                .multilineTextAlignment(.center) // Center-align the text within its bounds
                .frame(maxWidth: .infinity)
            Spacer()
            Button("Done") {
                showBuySuccessSheet = false
                showingTradeSheet = false
            }
            .padding(.horizontal, 150)
            .padding(.vertical)
            .foregroundColor(Color.green)
            .background(Color.white)
            .clipShape(Capsule())
            .padding()
//            .buttonStyle(FilledButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
        .foregroundColor(.white)
    }
}


#Preview {
    SuccessBuySheet(numberOfShares: "", companyName: "", showBuySuccessSheet: .constant(true), showingTradeSheet: .constant(true))
}
