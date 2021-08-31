//
//  HomeNavigator.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 24/08/2021.
//

import UIKit

protocol HomeNavigatorType {
    func toDetailScreen(uuid: String)
    func toSearchScreen()
    func toExchangeRatesScreen(defaultCurrency: String)
}

struct HomeNavigator: HomeNavigatorType {
    let navigationController: UINavigationController
    
    func toDetailScreen(uuid: String) {
        let detailScreen = DetailViewController.instance(navigationController: navigationController,
                                                         uuid: uuid)
        navigationController.pushViewController(detailScreen, animated: true)
    }
    
    func toSearchScreen() {
        let searchScreen = SearchViewController.instance(navigationController: navigationController)
        navigationController.pushViewController(searchScreen, animated: true)
    }
    
    func toExchangeRatesScreen(defaultCurrency: String) {
        let exchangeRatesScreen = ExchangeRatesViewController.instance(
            navigationController: navigationController,
            defaultCurrency: defaultCurrency)
        navigationController.pushViewController(exchangeRatesScreen,
                                                animated: true)
    }
}
