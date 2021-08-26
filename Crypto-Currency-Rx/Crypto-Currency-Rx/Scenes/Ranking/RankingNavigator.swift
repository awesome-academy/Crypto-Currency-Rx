//
//  RankingNavigator.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 25/08/2021.
//

import UIKit

protocol RankingNavigatorType {
    func toDetailScreen(uuid: String)
}

struct RankingNavigator: RankingNavigatorType {
    let navigationController: UINavigationController
    
    func toDetailScreen(uuid: String) {
        let detailScreen = DetailViewController.instance(uuid: uuid,
                                                         navigationController: navigationController)
        detailScreen.modalPresentationStyle = .pageSheet
        navigationController.present(detailScreen, animated: true, completion: nil)
    }
}
