//
//  ExchangeRatesUseCase.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 31/08/2021.
//

import Foundation
import RxSwift

protocol FavoriteUseCaseType {
    func getCoinsFavorite() -> Observable<[SimpleCoin]>
    func deleteCoinFavorite(uuid: String) -> Observable<Bool>
}

struct FavoriteUseCase: FavoriteUseCaseType {
    let dataRepository: DatabaseRepositoryType
    
    func getCoinsFavorite() -> Observable<[SimpleCoin]> {
        return dataRepository.getCoinsFavorite()
    }
    
    func deleteCoinFavorite(uuid: String) -> Observable<Bool> {
        return dataRepository.deleteFavoriteCoin(uuid: uuid)
    }
}
