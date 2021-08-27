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
        let selectSearchTrigger: Driver<Void>
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
                return useCase.getCoinsByCategory(category: .topCoin)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let topChange = input.loadTrigger
            .flatMapLatest { _ in
                return useCase.getCoinsByCategory(category: .topChange)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let top24hVolume = input.loadTrigger
            .flatMapLatest { _ in
                return useCase.getCoinsByCategory(category: .top24hVolume)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let topMarketCap = input.loadTrigger
            .flatMapLatest { _ in
                return useCase.getCoinsByCategory(category: .topMarketCap)
                    .asDriver(onErrorJustReturn: [])
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
        
        let searchSelected = input.selectSearchTrigger
            .do(onNext: navigator.toSearchScreen)
        
        let voidDrivers = [topCoinSelected,
                           topChangeSelected,
                           top24hVolumeSelected,
                           topMarketCapSelected,
                           searchSelected]
        
        return Output(topCoin: topCoin,
                      topChange: topChange,
                      top24hVolume: top24hVolume,
                      topMarketCap: topMarketCap,
                      voidDrivers: voidDrivers)
    }
}
