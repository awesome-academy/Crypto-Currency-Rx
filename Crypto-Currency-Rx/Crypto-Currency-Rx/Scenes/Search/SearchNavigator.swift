//
//  SearchNavigator.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 26/08/2021.
//

import UIKit

protocol SearchNavigatorType {
    func toDetailScreen(uuid: String)
    func backToScreen()
}

struct SearchNavigator: SearchNavigatorType {
    let navigationController: UINavigationController
    
    func toDetailScreen(uuid: String) {
        let detailScreen = DetailViewController.instance(navigationController: navigationController,
                                                         uuid: uuid)
        navigationController.pushViewController(detailScreen, animated: true)
    }
    
    func backToScreen() {
        navigationController.popViewController(animated: true)
    }
}
