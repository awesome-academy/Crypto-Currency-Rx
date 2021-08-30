//
//  RankingNavigator.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 25/08/2021.
//

import UIKit

protocol RankingNavigatorType {
    func toDetailScreen(uuid: String)
    func toSearchScreen()
}

struct RankingNavigator: RankingNavigatorType {
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
}
