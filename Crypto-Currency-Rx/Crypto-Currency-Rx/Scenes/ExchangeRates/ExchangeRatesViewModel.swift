//
//  ExchangeRatesViewModel.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 30/08/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct ExchangeRatesViewModel {
    let useCase: ExchangeRatesUseCaseType
    let navigator: ExchangeRatesNavigatorType
    let defaultCurrency: String
    
    struct Input {
        let loadCoinTrigger: Driver<Void>
        let loadPriceTrigger: Driver<[String]>
        let backTrigger: Driver<Void>
        let selectBaseTrigger: Driver<Void>
        let selectTargetTrigger: Driver<Void>
    }
    
    struct Output {
        let coin: Driver<[SimpleCoin]>
        let price: Driver<Price>
        let baseCurrency: Driver<SimpleCoin>
        let targetCurrency: Driver<SimpleCoin>
        let voidDriver: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let coin = input.loadCoinTrigger
            .flatMapLatest { _ in
                useCase.getSimpleCoin(name: defaultCurrency)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let price = input.loadPriceTrigger
            .flatMapLatest { uuids in
                useCase.getExchangeRates(base: uuids[0],
                                         target: uuids[1])
                    .asDriver(onErrorJustReturn: Price())
            }
        
        let baseSelected = input.selectBaseTrigger
            .flatMapLatest { _ -> Driver<SimpleCoin> in
                navigator.toSearchScreen(fromExchangeRatesScreen: true)
            }
        
        let targetSelected = input.selectTargetTrigger
            .flatMapLatest { _ -> Driver<SimpleCoin> in
                navigator.toSearchScreen(fromExchangeRatesScreen: true)
            }
        
        let backSelected = input.backTrigger
            .do(onNext: navigator.backToScreen)
            
        return Output(coin: coin,
                      price: price,
                      baseCurrency: baseSelected,
                      targetCurrency: targetSelected,
                      voidDriver: backSelected)
    }
}
