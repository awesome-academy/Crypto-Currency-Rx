//
//  RankingUseCase.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 25/08/2021.
//

import Foundation
import RxSwift

protocol RankingUseCaseType {
    func getCoins() -> Observable<[Coin]>
    func getMore(offset: String) -> Observable<[Coin]>
}

struct RankingUseCase: RankingUseCaseType {
    let coinRespository: CoinRepositoryType
    
    func getCoins() -> Observable<[Coin]> {
        let url = Network.shared.getRankingURL()
        return coinRespository.getCoins(url: url)
    }
    
    func getMore(offset: String) -> Observable<[Coin]> {
        return coinRespository.getMore(offset: offset)
    }
}
