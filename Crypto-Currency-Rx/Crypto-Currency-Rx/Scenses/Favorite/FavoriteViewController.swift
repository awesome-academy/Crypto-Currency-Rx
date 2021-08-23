//
//  FavoriteViewController.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import UIKit

final class FavoriteViewController: UIViewController {

    var viewModel: FavoriteViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite"
    }
    
}

extension FavoriteViewController {
    static func instance(navigationController: UINavigationController) -> FavoriteViewController {
        let favoriteScreen = FavoriteViewController()
        let viewModel = FavoriteViewModel()
        favoriteScreen.viewModel = viewModel
        return favoriteScreen
    }
}
