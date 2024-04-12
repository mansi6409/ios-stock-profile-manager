//
//  Details.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/6/24.
//

import Foundation
import SwiftUI

class Details: Decodable, Identifiable {
//    struct Details: Identifiable, Decodable {
        var id: UUID = UUID()  // Note: ensure your JSON actually contains a UUID if you're using this in a real app, or generate it as a placeholder
        var ticker: String
        var country: String?
        var name: String?
        var exchange: String?
        var logo: String?
        var ipo: String?
        var estimatedCurrency: String?
        var weburl: String?
        var finnhubIndustry: String?
    var peers: [String]?
        
        enum CodingKeys: String, CodingKey {
            case ticker = "ticker"
            case country = "country"
            case name = "name"
            case exchange = "exchange"
            case logo = "logo"
            case ipo = "ipo"
            case estimatedCurrency = "estimatedCurrency"/* = "estimated_currency" */ // Example of mapping a JSON key to a different property name
            case weburl = "weburl"
            case finnhubIndustry = "finnhubIndustry"
            case peers = "peers"
                // Add other mappings as necessary
        }
//    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ticker = try container.decode(String.self, forKey: .ticker)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        exchange = try container.decodeIfPresent(String.self, forKey: .exchange)
        logo = try container.decodeIfPresent(String.self, forKey: .logo)
        ipo = try container.decodeIfPresent(String.self, forKey: .ipo)
        estimatedCurrency = try container.decodeIfPresent(String.self, forKey: .estimatedCurrency)
        weburl = try container.decodeIfPresent(String.self, forKey: .weburl)
        finnhubIndustry = try container.decodeIfPresent(String.self, forKey: .finnhubIndustry)
        peers = try container.decodeIfPresent([String].self, forKey: .peers)
    }
    
    init() {
        self.id = UUID()  // Generate a new UUID
        self.ticker = ""
        self.country = ""
        self.name = ""
        self.exchange = ""
        self.logo = ""
        self.ipo = ""
        self.estimatedCurrency = ""
        self.weburl = ""
        self.finnhubIndustry = ""
        self.peers = []
    }

}
