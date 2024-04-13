//
//  Highchart.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/11/24.
//

import Foundation
import SwiftUI
import WebKit

struct HighchartsView: UIViewRepresentable {
//    @Published var chartType: String = ""
//    @Published var symbol: String = ""
    var chartOptions: String {
        let options: [String: Any] = [
            "rangeSelector": [
                "buttons": [
                    ["type": "month", "count": 1, "text": "1m", "title": "View 1 month"],
                    ["type": "month", "count": 6, "text": "6m", "title": "View 6 months"],
                    ["type": "month", "count": 3, "text": "3m", "title": "View 3 months"],
                    ["type": "ytd", "text": "YTD", "title": "View year to date"],
                    ["type": "year", "count": 1, "text": "1y", "title": "View 1 year"],
                    ["type": "all", "text": "All", "title": "View all"]
                ],
                "selected": 0,
                "enabled": true
            ],
//            "title": ["text": "\(symbol) Historical"],
            "xAxis": ["type": "datetime"],
            "subtitle": ["text": "With SMA and Volume by Price technical indicators"],
            "chart": ["backgroundColor": "#f0f000"],
            // ... include other options here
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: options, options: [])
        let jsonString = String(data: data, encoding: .utf8)!
        return jsonString
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let htmlString = """
            <html>
            <head>
                <script src="https://code.highcharts.com/highcharts.js"></script>
            </head>
            <body>
                <div id="container" style="height: 100%; width: 100%;"></div>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        var myChart = Highcharts.chart('container', \(chartOptions));
                    });
                </script>
            </body>
            </html>
            """
        
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}

