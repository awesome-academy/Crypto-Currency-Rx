//
//  Constants.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 24/08/2021.
//

import Foundation

enum CoinCategory: String, CaseIterable {
    case topCoin = "price"
    case topChange = "change"
    case top24hVolume = "24hVolume"
    case topMarketCap = "marketCap"
    case none = ""
}
