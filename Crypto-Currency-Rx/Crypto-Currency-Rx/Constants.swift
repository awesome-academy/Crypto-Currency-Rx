//
//  Constants.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 24/08/2021.
//

import UIKit

enum CoinCategory: String, CaseIterable {
    case topCoin = "price"
    case topChange = "change"
    case top24hVolume = "24hVolume"
    case topMarketCap = "marketCap"
    case none = ""
}

enum Select: String {
    case threeHours = "3h"
    case twentyFourHours = "24h"
    case sevenDays = "7d"
    case thirtyDays = "30d"
    case threeMonth = "3m"
}

func createSpinner(width: CGFloat) -> UIView {
    let uiView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 100))
    
    let spinner = UIActivityIndicatorView().then {
        $0.center = uiView.center
        $0.startAnimating()
    }
    
    uiView.addSubview(spinner)
    return uiView
}

enum DatabaseError: Error {
    case addCoinFailed
    case deleteCoinFailed
    case checkCoinExistFailed
    case getAllCoinFailed
}
