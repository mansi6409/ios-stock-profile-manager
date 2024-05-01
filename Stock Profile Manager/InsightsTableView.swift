//
//  InsightsTableView.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/30/24.
//

import SwiftUI

struct InsightsTableView: View {
    @State var model: ChartsModel = ChartsModel()
    @State private var isLoading = false
    var symbol: String = ""
    var companyName: String = ""
    
    init(symbol: String, companyName: String) {
        self.symbol = symbol
        self.companyName = companyName
    }

    var body: some View {
            VStack {
                Text("Insider Sentiments")
                    .font(.title3)
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(companyName)")
                            .bold()
                            .padding(.vertical, 5)
                        Divider()
                        Text("Total")
                            .bold()
                            .padding(.vertical, 5)
                        Divider()
                        Text("Positive")
                            .padding(.vertical, 5)
                            .bold()
                        Divider()
                        Text("Negative")
                            .padding(.vertical, 5)
                            .bold()
                        Divider()
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("MSPR")
                            .bold()
                            .padding(.vertical, 5)
                        Divider()
                        Text(String(format: "%.2f", model.sentimentsAggregate.mt))
                            .padding(.vertical, 5)
                        Divider()
                        Text(String(format: "%.2f", model.sentimentsAggregate.mp))
                            .padding(.vertical, 5)
                        Divider()
                        Text(String(format: "%.2f", model.sentimentsAggregate.mn))
                            .padding(.vertical, 5)
                        Divider()
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Change")
                            .bold()
                            .padding(.vertical, 5)
                        Divider()
                        Text(String(format: "%.2f", model.sentimentsAggregate.ct))
                            .padding(.vertical, 5)
                        Divider()
                        Text(String(format: "%.2f", model.sentimentsAggregate.cp))
                            .padding(.vertical, 5)
                        Divider()
                        Text(String(format: "%.2f", model.sentimentsAggregate.cn))
                            .padding(.vertical, 5)
                        Divider()
                    }
                }
//                .padding()
            }
//            .padding()
            .onAppear {
                isLoading = true
                model.fetchSentiments(symbol: symbol){
                    isLoading = false
                }
            }
        }
    
    
}

//
//#Preview {
//    InsightsTableView(symbol: String)
//}

