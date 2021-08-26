//
//  RankingViewController.swift
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

final class RankingViewController: UIViewController {

    @IBOutlet private weak var rankingTableView: UITableView!
    
    var viewModel: RankingViewModel!
    private var offset = 0
    private var isLoading = true
    private let loadMoreTrigger = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    private func configView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = L10n.Ranking.Navigation.title
        
        rankingTableView.do {
            $0.register(cellType: CoinTableViewCell.self)
            $0.rowHeight = 100
            $0.tableFooterView = UIView(frame: .zero)
            $0.tableHeaderView = UIView(frame: .zero)
            $0.delegate = self
        }
    }
    
    private func bindViewModel() {
        let loadTrigger = Driver.merge(Driver.just(0),
                                       loadMoreTrigger.asDriver(onErrorJustReturn: 0))
        let input = RankingViewModel.Input(
            loadMoreTrigger: loadTrigger.asDriver(onErrorDriveWith: .empty()),
            selectCoinTrigger: rankingTableView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.coins
            .do { [unowned self] in
                if !$0.isEmpty {
                    offset = $0.count
                    isLoading = false
                }
                rankingTableView.tableFooterView = nil
            }
            .drive(rankingTableView.rx.items) { (tableview, index, coin) in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = tableview.dequeueReusableCell(for: indexPath,
                                                         cellType: CoinTableViewCell.self)
                cell.configureCell(coin: coin)
                return cell
            }
            .disposed(by: rx.disposeBag)

        output.coinsDriver.forEach {
            $0.drive()
                .disposed(by: rx.disposeBag)
        }
    }
    
}

extension RankingViewController {
    static func instance(navigationController: UINavigationController) -> RankingViewController {
        let rankingScreen = RankingViewController()
        let useCase = RankingUseCase(coinRespository: CoinRepository())
        let navigator = RankingNavigator(navigationController: navigationController)
        let viewModel = RankingViewModel(useCase: useCase, navigator: navigator)
        rankingScreen.viewModel = viewModel
        return rankingScreen
    }
}

extension RankingViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let lastFrameTableView = (rankingTableView.contentSize.height - scrollView.frame.size.height + 50)
        
        if (position > lastFrameTableView) {
            rankingTableView.tableFooterView = createSpinner(width: view.frame.size.width)
            if !isLoading {
                loadMoreTrigger.onNext(offset)
            }
        }
    }
}
