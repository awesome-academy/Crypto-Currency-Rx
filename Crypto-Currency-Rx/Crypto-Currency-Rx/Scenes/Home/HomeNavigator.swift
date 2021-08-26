//
//  HomeNavigator.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 24/08/2021.
//

import UIKit

protocol HomeNavigatorType {
    func toDetailScreen(uuid: String)
}

struct HomeNavigator: HomeNavigatorType {
    let navigationController: UINavigationController
    
    func toDetailScreen(uuid: String) {
        let detailScreen = DetailViewController.instance(navigationController: navigationController,
                                                         uuid: uuid)
        detailScreen.modalPresentationStyle = .pageSheet
        navigationController.present(detailScreen, animated: true, completion: nil)
    }
}
