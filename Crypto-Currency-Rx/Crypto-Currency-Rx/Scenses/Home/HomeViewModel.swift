//
//  HomeViewModel.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct HomeViewModel {
    let useCase: HomeUseCaseType
    let navigator: HomeNavigatorType
    
    struct Input {
        let loadTrigger: Driver<Void>
        let selectopCoinTrigger: Driver<IndexPath>
        let selectopChangeTrigger: Driver<IndexPath>
        let selectop24hVolumeTrigger: Driver<IndexPath>
        let selectopMarketCapTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let topCoin: Driver<[Coin]>
        let topChange: Driver<[Coin]>
        let top24hVolume: Driver<[Coin]>
        let topMarketCap: Driver<[Coin]>
        let voidDrivers: [Driver<Void>]
    }
    
    func transform(input: Input) -> Output {
        let topCoin = input.loadTrigger
            .flatMapLatest { _ in
                return useCase.getCoins(category: .topCoin)
                    .asDriver(onErrorJustReturn: [])
                    .map { $0 }
            }
        
        let topChange = input.loadTrigger
            .flatMapLatest { _ in
                return useCase.getCoins(category: .topChange)
                    .asDriver(onErrorJustReturn: [])
                    .map { $0 }
            }
        
        let top24hVolume = input.loadTrigger
            .flatMapLatest { _ in
                return useCase.getCoins(category: .top24hVolume)
                    .asDriver(onErrorJustReturn: [])
                    .map { $0 }
            }
        
        let topMarketCap = input.loadTrigger
            .flatMapLatest { _ in
                return useCase.getCoins(category: .topMarketCap)
                    .asDriver(onErrorJustReturn: [])
                    .map { $0 }
            }
        
        let topCoinSelected = input.selectopCoinTrigger
            .withLatestFrom(topCoin) { (indexPath, coins) in
                coins[indexPath.item]
            }
            .do(onNext: {
                navigator.toDetailScreen(uuid: $0.uuid)
            })
            .map{ _ in }
        
        let topChangeSelected = input.selectopChangeTrigger
            .withLatestFrom(topChange) { (indexPath, coins) in
                coins[indexPath.item]
            }
            .do(onNext: {
                navigator.toDetailScreen(uuid: $0.uuid)
            })
            .map{ _ in }
        
        let top24hVolumeSelected = input.selectop24hVolumeTrigger
            .withLatestFrom(top24hVolume) { (indexPath, coins) in
                coins[indexPath.item]
            }
            .do(onNext: {
                navigator.toDetailScreen(uuid: $0.uuid)
            })
            .map{ _ in }
        
        let topMarketCapSelected = input.selectopMarketCapTrigger
            .withLatestFrom(topMarketCap) { (indexPath, coins) in
                coins[indexPath.item]
            }
            .do(onNext: {
                navigator.toDetailScreen(uuid: $0.uuid)
            })
            .map{ _ in }
        
        let voidDrivers = [topCoinSelected,
                           topChangeSelected,
                           top24hVolumeSelected,
                           topMarketCapSelected]
        
        return Output(topCoin: topCoin,
                      topChange: topChange,
                      top24hVolume: top24hVolume,
                      topMarketCap: topMarketCap,
                      voidDrivers: voidDrivers)
    }
}
