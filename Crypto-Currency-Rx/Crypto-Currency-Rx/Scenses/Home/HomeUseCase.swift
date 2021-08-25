//
//  HomeUseCase.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 24/08/2021.
//

import Foundation
import RxSwift

protocol HomeUseCaseType {
    func getCoins(category: CoinCategory) -> Observable<[Coin]>
}

struct HomeUseCase: HomeUseCaseType {
    let coinRepository: CoinRepositoryType
    
    func getCoins(category: CoinCategory) -> Observable<[Coin]> {
        return coinRepository.getCoins(category: category)
    }
}
