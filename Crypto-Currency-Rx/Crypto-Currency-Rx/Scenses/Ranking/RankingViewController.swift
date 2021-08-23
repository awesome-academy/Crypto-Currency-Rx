//
//  RankingViewController.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import UIKit

final class RankingViewController: UIViewController {

    var viewModel: RankingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ranking"
    }
    
}

extension RankingViewController {
    static func instance(navigationController: UINavigationController) -> RankingViewController {
        let rankingScreen = RankingViewController()
        let viewModel = RankingViewModel()
        rankingScreen.viewModel = viewModel
        return rankingScreen
    }
}
