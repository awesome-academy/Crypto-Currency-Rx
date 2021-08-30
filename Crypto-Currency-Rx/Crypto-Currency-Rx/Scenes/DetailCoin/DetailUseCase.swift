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
}

struct DetailUseCase: DetailUseCaseType {
    let coinRepository: CoinRepositoryType
    
    func getDetailCoin(uuid: String) -> Observable<CoinDetail> {
        return coinRepository.getDetailCoin(uuid: uuid)
    }
    
    func getHistoryPrice(time: String) -> Observable<[History]> {
        return coinRepository.getHistoryPrice(time: time)
    }
}
