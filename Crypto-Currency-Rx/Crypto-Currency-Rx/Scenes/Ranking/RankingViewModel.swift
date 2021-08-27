//
//  RankingViewModel.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct RankingViewModel {
    let useCase: RankingUseCaseType
    let navigator: RankingNavigatorType
    
    struct Input {
        let loadMoreTrigger: Driver<Int>
        let selectSearchTrigger: Driver<Void>
        let selectCoinTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let coins: Driver<[Coin]>
        let coinsDriver: [Driver<Void>]
    }
    
    func transform(input: Input) -> Output {
        let dataSource = BehaviorRelay<[Coin]>(value: [])
         
        let coinLoadMore = input.loadMoreTrigger
            .flatMapLatest { offset in
                return useCase.getMore(offset: String(offset))
                    .asDriver(onErrorJustReturn: [])
            }
            .do(onNext: {
                dataSource.accept(dataSource.value + $0)
            })
            .map{ _ in }
        
        let coinSelected = input.selectCoinTrigger
            .withLatestFrom(dataSource.asDriver()) { (indexPath, coins) in
                coins[indexPath.row]
            }
            .do(onNext: {
                navigator.toDetailScreen(uuid: $0.uuid)
            })
            .map{ _ in }
        
        let searchSelected = input.selectSearchTrigger
            .do(onNext: navigator.toSearchScreen)
        
        let coinsDrivers = [coinLoadMore, coinSelected, searchSelected]
        
        return Output(coins: dataSource.asDriver(),
                      coinsDriver: coinsDrivers)
    }
}
