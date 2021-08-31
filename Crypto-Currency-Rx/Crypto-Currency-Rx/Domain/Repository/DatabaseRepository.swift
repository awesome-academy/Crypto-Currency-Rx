//
//  DatabaseRepository.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 31/08/2021.
//

import Foundation
import RxSwift

protocol DatabaseRepositoryType {
    func isFavoriteCoin(uuid: String) -> Observable<Bool>
    func addFavoriteCoin(coin: SimpleCoin) -> Observable<Bool>
    func deleteFavoriteCoin(uuid: String) -> Observable<Bool>
    func getCoinsFavorite() -> Observable<[SimpleCoin]>
}

struct DatabaseRepository: DatabaseRepositoryType {
    func isFavoriteCoin(uuid: String) -> Observable<Bool> {
        return DatabaseManager.shared.checkCoinExist(uuid: uuid)
    }
    
    func addFavoriteCoin(coin: SimpleCoin) -> Observable<Bool> {
        return DatabaseManager.shared.addFavoriteCoin(coin: coin)
    }
    
    func deleteFavoriteCoin(uuid: String) -> Observable<Bool> {
        return DatabaseManager.shared.deleteFavoriteCoin(uuid: uuid)
    }
    
    func getCoinsFavorite() -> Observable<[SimpleCoin]> {
        return DatabaseManager.shared.getAllCoinFavorite()
    }
}
