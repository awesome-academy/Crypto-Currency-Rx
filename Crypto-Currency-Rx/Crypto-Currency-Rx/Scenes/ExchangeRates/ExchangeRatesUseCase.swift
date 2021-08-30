//
//  ExchangeRatesUseCase.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 30/08/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol ExchangeRatesUseCaseType {
    func getSimpleCoin(name: String) -> Observable<[SimpleCoin]>
    func getExchangeRates(base: String, target: String) -> Observable<Price>
}

struct ExchangeRatesUseCase: ExchangeRatesUseCaseType {
    let coinRepository: CoinRepositoryType
    
    func getSimpleCoin(name: String) -> Observable<[SimpleCoin]> {
        return coinRepository.getCoinByName(name: name)
    }
    
    func getExchangeRates(base: String, target: String) -> Observable<Price> {
        return coinRepository.getExchageRates(base: base, target: target)
    }
}
