//
//  SearchViewController.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 26/08/2021.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Then
import Reusable

final class SearchViewController: UIViewController {

    @IBOutlet private weak var coinsTableView: UITableView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: SearchViewModel!
    private let searchTrigger = PublishSubject<String>()
    private let headerRefreshTrigger = PublishRelay<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        dismissKeyboard()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configView() {
        searchBar.delegate = self
        
        coinsTableView.do {
            $0.register(cellType: SimpleCoinTableViewCell.self)
            $0.rowHeight = 70
            $0.tableFooterView = UIView(frame: .zero)
            $0.tableHeaderView = UIView(frame: .zero)
        }
        
        coinsTableView.refreshControl = UIRefreshControl()
        coinsTableView.refreshControl?.addTarget(self,
                                                 action: #selector(handleRefreshControl),
                                                 for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        guard let name = searchBar.searchTextField.text else {
            return
        }
        headerRefreshTrigger.accept((name))
        coinsTableView.refreshControl?.endRefreshing()
    }
    
    private func bindViewModel() {
        let searchTrigger = Driver.merge(searchTrigger.asDriver(onErrorJustReturn: ""),
                                         headerRefreshTrigger.asDriver(onErrorJustReturn: ""))
        
        let input = SearchViewModel.Input(
            searchTrigger: searchTrigger,
            cancelTrigger: cancelButton.rx.tap.asDriver(),
            selectCoinTrigger: coinsTableView.rx.itemSelected.asDriver())
        
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
        
        output.voidDrivers.forEach {
            $0.drive()
            .   disposed(by: rx.disposeBag)
        }
    }
    
}

extension SearchViewController {
    static func instance(navigationController: UINavigationController,
                         fromExchangeRatesScreen: Bool = false) -> SearchViewController {
        let searchScreen = SearchViewController()
        let useCase = SearchUseCase(coinRepository: CoinRepository())
        let navigator = SearchNavigator(navigationController: navigationController)
        let viewModel = SearchViewModel(useCase: useCase,
                                        navigator: navigator,
                                        fromExchangeRatesScreen: fromExchangeRatesScreen)
        
        searchScreen.viewModel = viewModel
        return searchScreen
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let name = searchBar.searchTextField.text else {
            return
        }
        searchTrigger.onNext(name)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
