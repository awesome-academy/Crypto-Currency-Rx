//
//  TabbarController.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import UIKit
import Then

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewControllers()
    }
    
    private func createTabbar(title: String, nameIcon: String) -> UITabBarItem {
        return UITabBarItem(title: title,
                            image: UIImage(named: nameIcon),
                            selectedImage: UIImage(named: nameIcon))
    }
    
    private func configViewControllers() {
        let homeNavigation = UINavigationController()
        let homeVC = HomeViewController.instance(navigationController: homeNavigation)
        homeNavigation.viewControllers.append(homeVC)
        homeVC.tabBarItem = createTabbar(title: "Home", nameIcon: "home")
        
        let rankingNavigation = UINavigationController()
        let rankingVC = RankingViewController.instance(navigationController: rankingNavigation)
        rankingNavigation.viewControllers.append(rankingVC)
        rankingVC.tabBarItem = createTabbar(title: "Ranking", nameIcon: "ranking")

        let favoriteNavigation = UINavigationController()
        let favoriteVC = FavoriteViewController.instance(navigationController: favoriteNavigation)
        favoriteNavigation.viewControllers.append(favoriteVC)
        favoriteVC.tabBarItem = createTabbar(title: "Favorite", nameIcon: "favorite")
        
        viewControllers = [homeNavigation, rankingNavigation, favoriteNavigation]
    }
}

