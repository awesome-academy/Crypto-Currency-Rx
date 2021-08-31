//
//  DetailViewModel.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 24/08/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct DetailViewModel {
    let useCase: DetailUseCaseType
    let navigator: DetailNavigatorType
    let uuid: String
    
    struct Input {
        let loadTrigger: Driver<Void>
        let loadHistoryTrigger: Driver<Select>
        let backTrigger: Driver<Void>
        let selectLinkTrigger: Driver<IndexPath>
        let addFavoriteTrigger: Driver<SimpleCoin>
        let deleteFavoriteTrigger: Driver<SimpleCoin>
        let checkFavoriteTrigger: Driver<SimpleCoin>
    }
    
    struct Output {
        let coin: Driver<CoinDetail>
        let history: Driver<[History]>
        let links: Driver<[Link]>
        let favoriteCoin: Driver<Bool>
        let voidDriver: [Driver<Void>]
    }
    
    func trasnform(input: Input) -> Output {
        let coin = input.loadTrigger
            .flatMapLatest { _ in
                return useCase.getDetailCoin(uuid: uuid)
                    .asDriver(onErrorJustReturn: CoinDetail())
            }
    
        let history = input.loadHistoryTrigger
            .flatMapLatest { select in
                return useCase.getHistoryPrice(time: select.rawValue)
                    .asDriver(onErrorJustReturn: [])
            }
        
        let links = coin.map { $0.links }
        
        let linkSelected = input.selectLinkTrigger
            .withLatestFrom(links) { (indexPath, links) in
                links[indexPath.row]
            }
            .do(onNext: {
                navigator.toSafariScreen(url: $0.url)
            })
            .map { _ in }
        
        let backSelected = input.backTrigger
            .do(onNext: navigator.backToScreen)
        
        let favoriteCoin = input.addFavoriteTrigger
            .flatMapLatest {
                return useCase.addFavoriteCoin(coin: $0)
                    .asDriver(onErrorDriveWith: .empty())
            }
            .map { _ in }
            
        let deleteCoin = input.deleteFavoriteTrigger
            .flatMapLatest {
                return useCase.deleteFavoriteCoin(uuid: $0.uuid)
                    .asDriver(onErrorDriveWith: .empty())
            }
            .map { _ in }
        
        let isFavoriteCoin = input.checkFavoriteTrigger
            .flatMapLatest {
                return useCase.checkFavoriteCoin(uuid: $0.uuid)
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        let voidDriver = [linkSelected,
                          backSelected,
                          favoriteCoin,
                          deleteCoin]
        
        return Output(coin: coin,
                      history: history,
                      links: links,
                      favoriteCoin: isFavoriteCoin,
                      voidDriver: voidDriver)
    }
}
