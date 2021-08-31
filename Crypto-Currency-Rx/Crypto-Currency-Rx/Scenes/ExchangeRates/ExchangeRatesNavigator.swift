//
//  ExchangeRatesNavigator.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 30/08/2021.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

protocol ExchangeRatesNavigatorType {
    func backToScreen()
    func toSearchScreen(fromExchangeRatesScreen: Bool) -> Driver<SimpleCoin>
}

struct ExchangeRatesNavigator: ExchangeRatesNavigatorType {
    let navigationController: UINavigationController
    
    func backToScreen() {
        navigationController.popViewController(animated: true)
    }
    
    func toSearchScreen(fromExchangeRatesScreen: Bool) -> Driver<SimpleCoin> {
        let searchScreen = SearchViewController.instance(
            navigationController: navigationController,
            fromExchangeRatesScreen: true)
        navigationController.pushViewController(searchScreen, animated: true)
        return searchScreen
            .viewModel
            .selectedCoinSubject
            .asDriver(onErrorJustReturn: SimpleCoin())
    }
}
