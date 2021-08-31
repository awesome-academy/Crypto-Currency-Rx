//
//  FavoriteViewModel.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct FavoriteViewModel {
    let useCase: FavoriteUseCaseType
    let navigator: FavoriteNavigatorType
    
    struct Input {
        let loadTrigger: Driver<Void>
        let selectCoinTrigger: Driver<IndexPath>
        let deleteCoinTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let coins: Driver<[SimpleCoin]>
        let coinSelected: Driver<Void>
        let coinDeleted: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let dataSource = BehaviorRelay<[SimpleCoin]>(value: [])
        
        let coins = input.loadTrigger
            .flatMapLatest { _ in
                return useCase.getCoinsFavorite()
                    .asDriver(onErrorJustReturn: [])
            }
            .do(onNext: dataSource.accept(_:))
        
        let coinSelected = input.selectCoinTrigger
            .withLatestFrom(coins) { (indexPath, coins) in
                coins[indexPath.row]
            }
            .do(onNext: {
                navigator.toDetailScreen(uuid: $0.uuid)
            })
            .map { _ in }
        
        let coinDeleted = input.deleteCoinTrigger
            .flatMapLatest { indexPath in
                return useCase.deleteCoinFavorite(uuid: dataSource.value[indexPath.row].uuid)
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        return Output(coins: coins,
                      coinSelected: coinSelected,
                      coinDeleted: coinDeleted)
    }
}
