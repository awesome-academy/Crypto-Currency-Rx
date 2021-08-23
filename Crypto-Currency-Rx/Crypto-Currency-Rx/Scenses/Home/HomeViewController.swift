//
//  HomeViewController.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import UIKit

final class HomeViewController: UIViewController {

    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
    }

}

extension HomeViewController {
    static func instance(navigationController: UINavigationController) -> HomeViewController {
        let homeScreen = HomeViewController()
        let viewModel = HomeViewModel()
        homeScreen.viewModel = viewModel
        return homeScreen
    }
}
