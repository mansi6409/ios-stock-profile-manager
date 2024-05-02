//
//  SuccessSellSheet.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/16/24.
//

import SwiftUI

struct SuccessSellSheet: View {
    var numberOfShares: String
    @State var companyName: String
    @Binding var showSellSuccessSheet: Bool
    @Binding var showingTradeSheet: Bool
    @Binding var allSharesSold: Bool
    var closeToHome: (_ val: Bool) -> Void
    @Binding var sellClosed: Bool
    

        
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Text("Congratulations!")
                .font(.largeTitle)
                .bold()
            Text("You have successfully sold \(numberOfShares) \(Double(numberOfShares) == 1 ? "share" : "shares") of \(companyName).")
                .font(.title3)
                .multilineTextAlignment(.center) // Center-align the text within its bounds
                .frame(maxWidth: .infinity) 
            Spacer()
            Button("Done") {
                print("Done button tapped")

                showSellSuccessSheet = false
//                showingTradeSheet = false
                if allSharesSold {
                    print("All shares sold, closing to home")
                    sellClosed = true
                    closeToHome(true)
                } else {
                    sellClosed = false
                    closeToHome(false)
                }
//                closeToHome()
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
    SuccessSellSheet(numberOfShares: "", companyName: "", showSellSuccessSheet: .constant(true), showingTradeSheet: .constant(true),allSharesSold: .constant(false), closeToHome: {val in}, sellClosed: .constant(false))
}

