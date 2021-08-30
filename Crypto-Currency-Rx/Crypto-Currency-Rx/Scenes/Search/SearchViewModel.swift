//
//  SearchViewModel.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 26/08/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchViewModel {
    let useCase: SearchUseCaseType
    let navigator: SearchNavigatorType
    let fromExchangeRatesScreen: Bool
    let selectedCoinSubject = PublishSubject<SimpleCoin>()
    
    struct Input {
        let searchTrigger: Driver<String>
        let cancelTrigger: Driver<Void>
        let selectCoinTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let coins: Driver<[SimpleCoin]>
        let voidDrivers: [Driver<Void>]
    }
    
    func transform(input: Input) -> Output {
        let coins = input.searchTrigger
            .flatMapLatest { name in
                useCase.getSimpleCoin(name: name)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let coinSelected = input.selectCoinTrigger
            .withLatestFrom(coins) { (indexPath, coins) in
                coins[indexPath.row]
            }
            .do(onNext: {
                if fromExchangeRatesScreen {
                    navigator.backToScreen()
                    selectedCoinSubject.onNext($0)
                } else {
                    navigator.toDetailScreen(uuid: $0.uuid)
                }
            })
            .map { _ in }
   
        let cancelSelected = input.cancelTrigger
            .do(onNext: { _ in
                navigator.backToScreen()
            })
        
        let voidDrivers = [coinSelected, cancelSelected]
       
        return Output(coins: coins, voidDrivers: voidDrivers)
    }
}
