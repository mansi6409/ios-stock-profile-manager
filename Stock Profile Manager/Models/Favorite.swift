//
//  Favorite.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/6/24.
//

import Foundation
class WatchlistModel {
    struct Watchlist: Identifiable {
        let id: UUID = UUID()
        var stockSymbol: String
    }
}
