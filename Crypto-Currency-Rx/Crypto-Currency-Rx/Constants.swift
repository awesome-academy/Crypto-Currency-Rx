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

func createSpinner(width: CGFloat) -> UIView {
    let uiView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 100))
    
    let spinner = UIActivityIndicatorView().then {
        $0.center = uiView.center
        $0.startAnimating()
    }
    
    uiView.addSubview(spinner)
    return uiView
}
