//
//  SearchUseCase.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 26/08/2021.
//

import Foundation
import RxSwift

protocol SearchUseCaseType {
    func getSimpleCoin(name: String) -> Observable<[SimpleCoin]>
}

struct SearchUseCase: SearchUseCaseType {
    let coinRepository: CoinRepositoryType
    
    func getSimpleCoin(name: String) -> Observable<[SimpleCoin]> {
        return coinRepository.getCoinByName(name: name)
    }
}
