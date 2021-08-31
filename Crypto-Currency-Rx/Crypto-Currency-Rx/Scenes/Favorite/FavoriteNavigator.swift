//
//  ExchangeRatesNavigator.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 31/08/2021.
//

import UIKit

protocol FavoriteNavigatorType {
    func toDetailScreen(uuid: String)
}

struct FavoriteNavigator: FavoriteNavigatorType {
    let navigationController: UINavigationController
    
    func toDetailScreen(uuid: String) {
        let detailScreen = DetailViewController.instance(navigationController: navigationController,
                                                         uuid: uuid)
        navigationController.pushViewController(detailScreen, animated: true)
    }
}
