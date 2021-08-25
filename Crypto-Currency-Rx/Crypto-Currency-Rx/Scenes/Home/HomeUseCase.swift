//
//  HomeUseCase.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 24/08/2021.
//

import Foundation
import RxSwift

protocol HomeUseCaseType {
    func getCoinsByCategory(category: CoinCategory) -> Observable<[Coin]>
}

struct HomeUseCase: HomeUseCaseType {
    let coinRepository: CoinRepositoryType
    
    func getCoinsByCategory(category: CoinCategory) -> Observable<[Coin]> {
        return coinRepository.getCoinsByCategory(category: category)
    }
}
