    //
    //  NewsDetailSheet.swift
    //  Stock Profile Manager
    //
    //  Created by Mansi Garg on 4/12/24.
    //

import SwiftUI

struct NewsDetailSheet: View {
    @Binding var selectedNewsItem: NewsItem?
        //    @Environment(DetailsViewModel.self) var viewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let source = self.selectedNewsItem?.source,
                       let dateTime = self.selectedNewsItem?.datetime,
                       let headline = self.selectedNewsItem?.headline,
                       let summary = self.selectedNewsItem?.summary,
                       let urlString = self.selectedNewsItem?.url,
                       
                        let url = URL(string: urlString) {
                        
                        Text(source)
                            .font(.title)
                            .bold()
                            .padding(0)
                        
                        Text(dateTime, formatter: dateFormatter)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(0)
                        
                        Divider()
                        VStack(alignment: .leading){
                            Text(headline)
                                .font(.headline)
                                .bold()
                            
                            Text(summary)
                                .font(.subheadline)
                            
                            HStack {
                                Text("For more details click")
                                    .foregroundColor(.gray)
                                Link("here", destination: url) // Sequential link
                                    .foregroundColor(.blue) // Optionally style it
                            }
                            .font(.footnote)
                            
                            HStack(spacing: 12) {
                                Link(destination: URL(string: "https://twitter.com/intent/tweet?text=\(headline)&url=\(urlString)")!) {
                                    Image("twitterIcon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 55)
                                        .foregroundColor(.blue)
                                }
                                
                                Link(destination: URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(urlString)")!) {
                                    Image("fbIcon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 55)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.top, 10)
                        }
                        
                    } else {
                        Text("Invalid News Data")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                    //                .navigationBarTitle("News Details", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark") // Use a cross icon
                        .foregroundColor(.gray) // Style it to be grey
                        .font(.subheadline)
                        .bold()
                })
                
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long // Set only the date style
        formatter.timeStyle = .none // Ensure no time style is set
        return formatter
    }

    private func truncatedText(_ text: String) -> String {
        let lines = text.components(separatedBy: .newlines) // Split into lines
        let truncatedLines = lines.prefix(5) // Take up to 5 lines
        let truncatedText = truncatedLines.joined(separator: "\n") // Reconstruct text
        
        if lines.count > 5 { // Add ellipsis if truncation occurred
            return truncatedText + " [...]"
        }
        
        return truncatedText
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
    NewsDetailSheet(selectedNewsItem: .constant(MockData.sampleNewsItem))
}
