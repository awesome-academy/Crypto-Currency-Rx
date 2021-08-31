//
//  DetailUseCase.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 27/08/2021.
//

import Foundation
import RxSwift

protocol DetailUseCaseType {
    func getDetailCoin(uuid: String) -> Observable<CoinDetail>
    func getHistoryPrice(time: String) -> Observable<[History]>
    func addFavoriteCoin(coin: SimpleCoin) -> Observable<Bool>
    func deleteFavoriteCoin(uuid: String) -> Observable<Bool>
    func checkFavoriteCoin(uuid: String) -> Observable<Bool>
}

struct DetailUseCase: DetailUseCaseType {
    let coinRepository: CoinRepositoryType
    let databaseRepository: DatabaseRepositoryType
    
    func getDetailCoin(uuid: String) -> Observable<CoinDetail> {
        return coinRepository.getDetailCoin(uuid: uuid)
    }
    
    func getHistoryPrice(time: String) -> Observable<[History]> {
        return coinRepository.getHistoryPrice(time: time)
    }
    
    func addFavoriteCoin(coin: SimpleCoin) -> Observable<Bool> {
        return databaseRepository.addFavoriteCoin(coin: coin)
    }
    
    func deleteFavoriteCoin(uuid: String) -> Observable<Bool> {
        return databaseRepository.deleteFavoriteCoin(uuid: uuid)
    }
    
    func checkFavoriteCoin(uuid: String) -> Observable<Bool> {
        return databaseRepository.isFavoriteCoin(uuid: uuid)
    }
}
