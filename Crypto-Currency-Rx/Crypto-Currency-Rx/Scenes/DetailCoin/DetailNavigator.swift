//
//  DetailNavigator.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 27/08/2021.
//

import UIKit
import SafariServices

protocol DetailNavigatorType {
    func backToScreen()
    func toSafariScreen(url: String)
}

struct DetailNavigator: DetailNavigatorType {
    let navigationController: UINavigationController
    
    func backToScreen() {
        navigationController.popViewController(animated: true)
    }
    
    func toSafariScreen(url: String) {
        if let url = URL(string: url) {
            let safariScreen = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            navigationController.present(safariScreen, animated: true)
        }
    }
}
