//
//  Wallet.swift
//  Stock Profile Manager
//
//  Created by Mansi Garg on 4/6/24.
//

import Foundation

class WalletModel {
    struct Wallet: Identifiable {
        let id: UUID = UUID()
        var walletMoney: Double
    }
}



