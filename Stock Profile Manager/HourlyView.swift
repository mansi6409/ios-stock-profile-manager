//
//  HourlyView.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/29/24.
//

import SwiftUI

struct HourlyView: View {
    @State var chartsModel: ChartsModel = ChartsModel()
    @State private var isLoading = false
    var ticker: String = ""
    var color: String = ""
    init(ticker: String, color: String) {
        self.ticker = ticker
        self.color = color
    }
    
    var highchartsContent: String {
    """
    <!DOCTYPE html>
    <html>
    <head>
    <title>Highcharts Example</title>
    <script src="https://code.highcharts.com/highcharts.js"></script>
    </head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <body>
    <div id="container" style="height:400px;"></div>
    <script>
    Highcharts.chart('container', {
        title: {
        text: `\(self.ticker) Hourly Price Variation`,
        align: 'center'
        },
        yAxis: {
        title: {
            text: ''
        },
        opposite: true,
        },
        xAxis: {
        type: 'datetime',
        },
        tooltip: {
          split: true
        },
        plotOptions: {
        series: {
            label: {
                connectorAllowed: false
            },
            marker: {
              enabled: false
            },
            pointStart: 2010
        }
        },
        series: [
        {
          name: '\(self.ticker)',
          type: 'line',
          data: \(chartsModel.filteredtimehistory),
          color: '\(self.color)'
        }
        ],
        legend: {
        enabled: false
        }
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
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear() {
            isLoading = true
            chartsModel.fetchTimeHistoryData(ticker: ticker)
            {
            isLoading = false
            }
        }
    }
}

#Preview {
    HourlyView(ticker: "TSLA", color: "green")
        .environment(ChartsModel())
}

