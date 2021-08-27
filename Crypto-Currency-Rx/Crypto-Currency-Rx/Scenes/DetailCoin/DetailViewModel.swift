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
    }
    
    struct Output {
        let coin: Driver<CoinDetail>
        let history: Driver<[History]>
        let links: Driver<[Link]>
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
        
        let voidDriver = [linkSelected, backSelected]
        
        return Output(coin: coin,
                      history: history,
                      links: links,
                      voidDriver: voidDriver)
    }
}
