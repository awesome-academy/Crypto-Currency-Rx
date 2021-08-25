//
//  DetailViewController.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 24/08/2021.
//

import UIKit

final class DetailViewController: UIViewController {

    var viewModel: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
    }

}

extension DetailViewController {
    static func instance(uuid: String,
                         navigationController: UINavigationController) -> DetailViewController {
        let detailScreen = DetailViewController()
        let viewModel = DetailViewModel(uuid: uuid)
        detailScreen.viewModel = viewModel
        return detailScreen
    }
}
