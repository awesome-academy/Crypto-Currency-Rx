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
    func getCoinsByCategory(category: CoinCategory) -> Observable<[Coin]>
    func getCoins(url: String) -> Observable<[Coin]>
    func getMore(offset: String) -> Observable<[Coin]>
    func getHistoryPrice(time: String) -> Observable<[History]>
    func getExchageRates(base: String, target: String) -> Observable<Price>
}

struct CoinRepository: CoinRepositoryType {
    func getCoinsByCategory(category: CoinCategory) -> Observable<[Coin]> {
        let url = Network.shared.getCoinsURL(category: category)
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
                      let coins = data.coins else { return [] }
                return coins
            }
            .catchAndReturn([])
    }
    
    func getDetailCoin(uuid: String) -> Observable<CoinDetail> {
        let url = Network.shared.getDetailURL(uuid: uuid)
        return APIService.shared.request(url: url,
                                         expecting: CoinResponse<DataDetailCoin>.self)
            .map { response -> CoinDetail in
                guard let data = response.data,
                      let coin = data.coin else { return CoinDetail() }
                return coin
            }
            .catchAndReturn(CoinDetail())
    }
    
    func getCoins(url: String) -> Observable<[Coin]> {
        return APIService.shared.request(url: url,
                                         expecting: CoinResponse<DataCoin>.self)
            .map { response -> [Coin] in
                guard let data = response.data,
                      let coins = data.coins else { return [] }
                return coins
            }
            .catchAndReturn([])
    }
    
    func getMore(offset: String) -> Observable<[Coin]> {
        let url = Network.shared.getOffsetURL(offset: offset)
        return APIService.shared.request(url: url,
                                         expecting: CoinResponse<DataCoin>.self)
            .map { response -> [Coin] in
                guard let data = response.data,
                      let coins = data.coins else { return [] }
                return coins
            }
            .catchAndReturn([])
    }
    
    func getHistoryPrice(time: String) -> Observable<[History]> {
        let url = Network.shared.getHistoryURL(time: time)
        return APIService.shared.request(url: url,
                                         expecting: CoinResponse<PriceHistory>.self)
            .map { response -> [History] in
                guard let data = response.data,
                      let history = data.history else { return [] }
                return history
            }
            .catchAndReturn([])
    }
    
    func getExchageRates(base: String, target: String) -> Observable<Price> {
        let url = Network.shared.getExchangeRates(base: base, target: target)
        return APIService.shared.request(url: url,
                                         expecting: CoinResponse<Price>.self)
            .map { response -> Price in
                guard let price = response.data else { return Price() }
                return price
            }
            .catchAndReturn(Price())
    }
}

