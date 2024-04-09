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

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
                // Company name, logo, and other details
            Text((viewModel.companyInfo?.name) ?? "")
                // Assuming `companyLogo` is a UIImage or similar that can be displayed.
//            Image(uiImage: viewModel.companyInfo?.logo)
//                .resizable()
//                .frame(width: 50, height: 50)
            HStack {
                Text("$\((viewModel.stockPriceDetails?.c ?? 0), specifier: "%.2f")")
//                Text("\(viewModel.stockPriceDetails. >= 0 ? "+" : "")\(viewModel.change, specifier: "%.2f") (\(viewModel.changePercentage, specifier: "%.2f")%)")
//                    .foregroundColor(viewModel.change > 0 ? .green : (viewModel.change < 0 ? .red : .gray))
            }
        }
    }
}

#Preview {
    StockDataView(symbol: "")
}
