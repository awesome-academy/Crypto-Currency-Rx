//
//  DatabaseManager.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 31/08/2021.
//

import Foundation
import RxSwift
import Then
import CoreData

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let presistentContainer: NSPersistentContainer
    
    private init() {
        presistentContainer = NSPersistentContainer(name: "FavoriteCoin")
        presistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                print("Load Coins Database failed: \(error.localizedDescription)")
            }
        }
    }
    
    func checkCoinExist(uuid: String) -> Observable<Bool> {
        let context = presistentContainer.viewContext
        let request = FavoriteCoin.fetchRequest() as NSFetchRequest<FavoriteCoin>
        
        return Observable.create { observer in
            do {
                let coins = try context.fetch(request)
                observer.onNext(coins.contains(where: { $0.uuid == uuid }))
                observer.onCompleted()
            } catch {
                observer.onError(DatabaseError.checkCoinExistFailed)
            }
            return Disposables.create()
        }
    }
    
    func getAllCoinFavorite() -> Observable<[SimpleCoin]> {
        let context = presistentContainer.viewContext
        
        return Observable.create { observer in
            do {
                let request = FavoriteCoin.fetchRequest() as NSFetchRequest<FavoriteCoin>
                let coinsEntity = try context.fetch(request)
                
                let coins = coinsEntity.map { coin -> SimpleCoin in
                    return SimpleCoin(uuid: coin.uuid ?? "",
                                      symbol: coin.symbol ?? "",
                                      name: coin.name ?? "",
                                      iconUrl: coin.iconUrl ?? "")
                }
                observer.onNext(coins)
                observer.onCompleted()
            } catch {
                observer.onError(DatabaseError.getAllCoinFailed)
            }
            return Disposables.create()
        }
    }
    
    func addFavoriteCoin(coin: SimpleCoin) -> Observable<Bool> {
        let context = presistentContainer.viewContext
        
        return Observable.create { observer in
            do {
                FavoriteCoin(context: context).do {
                    $0.uuid = coin.uuid
                    $0.name = coin.name
                    $0.symbol = coin.symbol
                    $0.iconUrl = coin.iconUrl
                }
                try context.save()
                observer.onNext(true)
                observer.onCompleted()
            } catch {
                observer.onError(DatabaseError.addCoinFailed)
            }
            return Disposables.create()
        }
    }
    
    func deleteFavoriteCoin(uuid: String) -> Observable<Bool> {
        let context = presistentContainer.viewContext
        let request = FavoriteCoin.fetchRequest() as NSFetchRequest<FavoriteCoin>
        
        return Observable.create { observer in
            do {
                if let coins = try? context.fetch(request) {
                    for coin in coins where coin.uuid == uuid {
                        context.delete(coin)
                        try context.save()
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                }
            } catch {
                observer.onError(DatabaseError.deleteCoinFailed)
            }
            return Disposables.create()
        }
    }
}
