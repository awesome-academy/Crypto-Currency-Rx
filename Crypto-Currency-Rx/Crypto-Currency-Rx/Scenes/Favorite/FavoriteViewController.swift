//
//  FavoriteViewController.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Then
import Reusable

final class FavoriteViewController: UIViewController {
    
    @IBOutlet private weak var coinsTableView: UITableView!
    
    var viewModel: FavoriteViewModel!
    private let loadTrigger = PublishSubject<Void>()
    private let coinDeleteTrigger = PublishSubject<IndexPath>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTrigger.onNext(())
    }
    
    private func configView() {
        navigationItem.title = L10n.favorite
        
        coinsTableView.do {
            $0.register(cellType: SimpleCoinTableViewCell.self)
            $0.rowHeight = 70
            $0.tableFooterView = UIView(frame: .zero)
            $0.tableHeaderView = UIView(frame: .zero)
            $0.delegate = self
        }
    }
    
    private func bindViewModel() {
        let input = FavoriteViewModel.Input(
            loadTrigger: loadTrigger.asDriver(onErrorJustReturn: ()),
            selectCoinTrigger: coinsTableView.rx.itemSelected.asDriver(),
            deleteCoinTrigger: coinDeleteTrigger.asDriver(onErrorDriveWith: .empty()))
        
        let output = viewModel.transform(input: input)
        
        output.coins
            .drive(coinsTableView.rx.items) { (tableview, index, coin) in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = tableview.dequeueReusableCell(for: indexPath,
                                                         cellType: SimpleCoinTableViewCell.self)
                cell.configureCell(coin: coin)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.coinSelected
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.coinDeleted
            .drive()
            .disposed(by: rx.disposeBag)
    }
}

extension FavoriteViewController {
    static func instance(navigationController: UINavigationController) -> FavoriteViewController {
        let favoriteScreen = FavoriteViewController()
        let useCase = FavoriteUseCase(dataRepository: DatabaseRepository())
        let navigator = FavoriteNavigator(navigationController: navigationController)
        let viewModel = FavoriteViewModel(useCase: useCase,
                                          navigator: navigator)
        favoriteScreen.viewModel = viewModel
        return favoriteScreen
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(
            style: .destructive,
            title: L10n.delete) { [unowned self] _, indexPath in
            coinDeleteTrigger.onNext(indexPath)
            loadTrigger.onNext(())
        }
        return [action]
    }
}
