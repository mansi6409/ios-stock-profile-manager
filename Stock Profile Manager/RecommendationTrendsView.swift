//
//  RecommendationTrendsView.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/29/24.
//

import SwiftUI

struct RecommendationTrendsView: View {
    @State var chartsModel: ChartsModel = ChartsModel()
    @State private var isLoading = false
    var ticker: String = ""
    init(ticker: String) {
        self.ticker = ticker
    }
    
    var highchartsContent: String {
    """
    <!DOCTYPE html>
    <html>
    <head>
    <title>Highcharts Example</title>
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="https://code.highcharts.com/modules/export-data.js"></script>
    <script src="https://code.highcharts.com/modules/accessibility.js"></script>
    </head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <body>
    <div id="container" style="height:400px"></div>
    <script>
    Highcharts.chart('container', {
        chart: {
            type: 'column',
        },
        title: {
            text: `Recommendation Trends`,
            align: 'center'
        },
        yAxis: {
            min: 0,
            title: {
                text: '#Analysis'
            }
        },
        xAxis: {
            categories: \(chartsModel.dates)
        },
        legend: {
            verticalAlign: 'bottom',
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: true
                }
            }
        },
        series: [
            {
                type: 'column',
                name: 'Strong Buy',
                data: \(chartsModel.strongbuy),
                color: "green",
            },
            {
                type: 'column',
                name: 'Buy',
                data: \(chartsModel.buy),
                color: "#4aba67",
            },
            {
                type: 'column',
                name: 'Hold',
                data: \(chartsModel.hold),
                color: "#c7a748",
            },
            {
                type: 'column',
                name: 'Sell',
                data: \(chartsModel.sell),
                color: "#a56c1b",
            },
            {
                type: 'column',
                name: 'Strong Sell',
                data: \(chartsModel.strongsell),
                color: "#a5321b",
            }
        ]
    });
    </script>
    </body>
    </html>
    """
    }
    
    var body: some View {
        VStack {
            if (isLoading == true) {
                    //                Spacer()
                    //                HStack {
                    //                    ProgressView()
                    //                        .progressViewStyle(CircularProgressViewStyle())
                    //                }
                    //                Text("Fetching Data...")
                    //                .padding(5)
                    //                .foregroundStyle(.secondary)
                    //                Spacer()
            }
            else {
                MainHighchartsView(htmlContent: highchartsContent)
                    //                    .frame(maxWidth: .infinity)  // Fill the available space
                
                    //                    .frame(width: 110, height: 100)
                    //                      .border(Color.red)
                    //                      .clipped()
                    //                        .background(Color.blue)
                    //                        .edgesIgnoringSafeArea(.all)
            }
        }
//        .frame(width: 110, height: 99)
//        .clipped()
        .onAppear() {
            isLoading = true
            chartsModel.fetchTrends(ticker: ticker)
            {
            isLoading = false
            }
        }
    }
}

#Preview {
    RecommendationTrendsView(ticker: "TSLA")
        .environment(ChartsModel())
}



    //                    .frame(width: UIScreen.main.bounds.width, height: 400)
    ////                    .frame(maxWidth: .infinity)
    //                    .background(Color.blue)

    //                    .frame(width: UIScreen.main.bounds.width, height: 400)

    //                                    }
    //                                        .frame(maxWidth: .infinity)

    //                                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

    //                                        .frame(maxWidth: .infinity, maxHeight: 400)


    //                            .edgesIgnoringSafeArea(.all)
