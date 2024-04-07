//
//  DetailsView.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/6/24.
//

import SwiftUI

struct DetailsView: View {
    @ObservedObject var viewModel = DetailsViewModel()

    var body: some View {
        List{
            HStack {
                Spacer()
                Text(currentDateString())
                    .bold()
                    .foregroundColor(.gray)
                    .padding(.vertical)
                    .padding(.horizontal, 10.0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(9)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
//                Spacer()
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal, -26)
//            .padding(.horizontal, 0)
            .listRowBackground(Color(.systemGroupedBackground))
            Text(viewModel.stockDetail?.ticker ?? "Search for a stock")
                .padding(.top, 10)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)


        }.background(Color(.systemGroupedBackground))
    }
    
    func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: Date())
    }
}

//#Preview {
//    DetailsView(viewModel: <#DetailsViewModel#>)
//}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(viewModel: DetailsViewModel())
    }
}
