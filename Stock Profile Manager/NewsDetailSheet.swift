//
//  NewsDetailSheet.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/12/24.
//

import SwiftUI

struct NewsDetailSheet: View {
    let newsItem: NewsItem
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(newsItem.source!)
                        .font(.headline)
                    
                    Text(newsItem.datetime!, formatter: itemFormatter)
                        .font(.subheadline)
                    
                    Text(newsItem.headline!)
                        .font(.title)
                        .bold()
                    
                    Text(newsItem.summary!)
                        .font(.body)
                    
                    Link("Read More", destination: URL(string: newsItem.url!)!)
                    
                        // Social sharing buttons here
                    
                }
                .padding()
                .navigationBarTitle("News Details", displayMode: .inline)
                .navigationBarItems(trailing: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
    
    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
}

struct MockData {
    static let sampleNewsItem = NewsItem(
        id: 123,
        headline: "Sample Headline",
        summary: "Sample Summary",
        image: "SampleImageURL",
        url: "https://example.com",
        source: "Example Source",
        datetime: Date()
    )
}

#Preview {
    NewsDetailSheet(newsItem: MockData.sampleNewsItem)
}
