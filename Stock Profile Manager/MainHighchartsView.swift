    //
    //  MainHighchartsView.swift
    //  Stock Profile Manager
    //
    //  Created by Mansi Garg on 4/29/24.
    //

import SwiftUI
import WebKit
import Kingfisher

struct MainHighchartsView: View {
    let htmlContent: String
    
    var body: some View {
        HighchartsWebView(htmlContent: htmlContent)
    }
}

struct HighchartsWebView: UIViewRepresentable {
    let htmlContent: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
