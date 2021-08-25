//
//  UILabel+Extensions.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 24/08/2021.
//

import UIKit

public extension UILabel {
    func edgeTo(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func formatChange(percentChange: String) {
        guard let percent = Double(percentChange) else {
            return
        }
        text = "\(String(format: "%.2f", percent))%"
        textColor = percent > 0 ? .green : .red
    }
    
    func formatPrice(price: String) {
        guard let price = Double(price) else {
            return
        }
        text =  "\(String(format: price > 1 ? "%.2f" : "%.5f", price)) US$"
    }
    
    func formatMarketCap(marketCap: String) {
        guard let marketCap = Double(marketCap) else {
            return
        }
        text = "\(String(format: "%.2f", marketCap / 1000000000)) Bn"
    }
    
    func formatTotal(marketCap: String) {
        guard let marketCap = Double(marketCap) else {
            return
        }
        text = "\(String(format: "%.2f", marketCap / 1000000)) M"
    }
}

