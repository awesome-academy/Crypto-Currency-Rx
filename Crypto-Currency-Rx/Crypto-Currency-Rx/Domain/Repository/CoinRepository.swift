//
//  CoinRepository.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import Foundation
import RxSwift

protocol CoinRepositoryType {
    func getCoinByName(name: String) -> Observable<[SimpleCoin]>
    func getDetailCoin(uuid: String) -> Observable<CoinDetail>
    func getCoins(url: String) -> Observable<[Coin]>
}

struct CoinRepository: CoinRepositoryType {
    func getCoins(url: String) -> Observable<[Coin]> {
        return APIService.shared.request(url: url,
                                         expecting: CoinResponse<DataCoin>.self )
            .map { response -> [Coin] in
                guard let data = response.data,
                      let coins = data.coins else { return [] }
                return coins
            }
            .catchAndReturn([])
    }
    
    func getCoinByName(name: String) -> Observable<[SimpleCoin]> {
        let url = Network.shared.getSearchURL(name: name)
        return APIService.shared.request(url: url,
                                         expecting: CoinResponse<DataSimpleCoin>.self)
            .map { response -> [SimpleCoin] in
                guard let data = response.data,
                      let coins = data.coin else { return [] }
                return coins
            }
            .catchAndReturn([])
    }
    
    func getDetailCoin(uuid: String) -> Observable<CoinDetail> {
        let url = Network.shared.getDetailURL(uuid: uuid)
        return APIService.shared.request(url: url,
                                         expecting: CoinDetail.self)
    }

}

