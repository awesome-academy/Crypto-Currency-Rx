//
//  HomeViewController.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import UIKit
import Then
import RxCocoa
import RxSwift
import Reusable
import RxDataSources
import NSObject_Rx

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var exchangeRatesButton: UIButton!
    @IBOutlet private weak var topCoinCollection: UICollectionView!
    @IBOutlet private weak var topChangeCollection: UICollectionView!
    @IBOutlet private weak var top24hVolumeCollection: UICollectionView!
    @IBOutlet private weak var topMarketCapCollection: UICollectionView!
    
    var viewModel: HomeViewModel!
    private let selectCoinTrigger = PublishSubject<String>()
    private let headerRefreshTrigger = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    private func configView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Home"
        
        let layout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.itemSize = CGSize(width: 150, height: 150)
            $0.minimumInteritemSpacing = 5
            $0.minimumLineSpacing = 24
            $0.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        topCoinCollection.collectionViewLayout = layout
        topCoinCollection.register(cellType: CoinCollectionViewCell.self)
        
        topChangeCollection.collectionViewLayout = layout
        topChangeCollection.register(cellType: CoinCollectionViewCell.self)
        
        top24hVolumeCollection.collectionViewLayout = layout
        top24hVolumeCollection.register(cellType: CoinCollectionViewCell.self)
        
        topMarketCapCollection.collectionViewLayout = layout
        topMarketCapCollection.register(cellType: CoinCollectionViewCell.self)
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self,
                                             action: #selector(handleRefreshControl),
                                             for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        headerRefreshTrigger.accept(())
        scrollView.refreshControl?.endRefreshing()
    }
    
    private func bindViewModel() {
        let loadTrigger = Driver.merge(Driver.just(()),
                                       headerRefreshTrigger.asDriver(onErrorJustReturn: ()))
        let input = HomeViewModel.Input(
            loadTrigger: loadTrigger,
            selectopCoinTrigger: topCoinCollection.rx.itemSelected.asDriver(),
            selectopChangeTrigger: topChangeCollection.rx.itemSelected.asDriver(),
            selectop24hVolumeTrigger: top24hVolumeCollection.rx.itemSelected.asDriver(),
            selectopMarketCapTrigger: topMarketCapCollection.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.topCoin
            .drive(topCoinCollection.rx.items) { (collection, index, coin) in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = collection.dequeueReusableCell(for: indexPath,
                                                          cellType: CoinCollectionViewCell.self)
                cell.configureCell(coin: coin)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.topChange
            .drive(topChangeCollection.rx.items) { (collection, index, coin) in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = collection.dequeueReusableCell(for: indexPath,
                                                          cellType: CoinCollectionViewCell.self)
                cell.configureCell(coin: coin)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.top24hVolume
            .drive(top24hVolumeCollection.rx.items) { (collection, index, coin) in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = collection.dequeueReusableCell(for: indexPath,
                                                          cellType: CoinCollectionViewCell.self)
                cell.configureCell(coin: coin)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.topMarketCap
            .drive(topMarketCapCollection.rx.items) { (collection, index, coin) in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = collection.dequeueReusableCell(for: indexPath,
                                                          cellType: CoinCollectionViewCell.self)
                cell.configureCell(coin: coin)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.voidDrivers.forEach {
            $0.drive()
                .disposed(by: rx.disposeBag)
        }
    }
    
}

extension HomeViewController {
    static func instance(navigationController: UINavigationController) -> HomeViewController {
        let homeScreen = HomeViewController()
        let useCase = HomeUseCase(coinRepository: CoinRepository())
        let navigator = HomeNavigator(navigationController: navigationController)
        let viewModel = HomeViewModel(useCase: useCase, navigator: navigator)
        homeScreen.viewModel = viewModel
        return homeScreen
    }
}

