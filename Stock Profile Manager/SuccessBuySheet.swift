//
//  SuccessBuySheet.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/13/24.
//

import SwiftUI

struct SuccessBuySheet: View {
    @Binding var sharesBought: String
    @State var companyName: String
    @Binding var showBuySuccessSheet: Bool
    @Binding var showingTradeSheet: Bool

//    var onDone: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Congratulations!")
                .font(.largeTitle)
                .bold()
            Text("You have successfully bought \(sharesBought) shares of \(companyName).")
            Spacer()
            Button("Done") {
                showBuySuccessSheet = false
                showingTradeSheet = false
            }
            .buttonStyle(FilledButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
        .foregroundColor(.white)
    }
}


#Preview {
    SuccessBuySheet(sharesBought: .constant(""), companyName: "", showBuySuccessSheet: .constant(true), showingTradeSheet: .constant(true))
}
