//
//  SuccessSellSheet.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/16/24.
//

import SwiftUI

struct SuccessSellSheet: View {
    @Binding var sharesSold: String
    @State var companyName: String
    @Binding var showSellSuccessSheet: Bool
    @Binding var showingTradeSheet: Bool
    @Binding var allSharesSold: Bool
    var closeToHome: (_ val: Bool) -> Void
    @Binding var sellClosed: Bool
    

        
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Congratulations!")
                .font(.largeTitle)
                .bold()
            Text("You have successfully sold \(sharesSold) shares of \(companyName).")
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
            .buttonStyle(FilledButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
        .foregroundColor(.white)
    }
}


#Preview {
    SuccessSellSheet(sharesSold: .constant(""), companyName: "", showSellSuccessSheet: .constant(true), showingTradeSheet: .constant(true),allSharesSold: .constant(false), closeToHome: {val in}, sellClosed: .constant(false))
}

