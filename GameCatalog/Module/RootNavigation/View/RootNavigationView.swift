//
//  RootNavigationView.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import UIKit

class RootNavigationView: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let r = Injection.sharedInstance
        r.registerAll()
        
        let homeUseCase = r.provideHomeUC()
        let homePresenter = HomeViewPresenter(useCase: homeUseCase)
        
        let favoriteUseCase = r.provideFavoriteUC()
        let favoritePresenter = FavoritePresenter(useCase: favoriteUseCase)
        
        let devProfilePresenter = DevProfilePresenter()
        
        let gameListController = UINavigationController(rootViewController: HomeView(presenter: homePresenter))
        
        let favoriteListController = UINavigationController(rootViewController: FavoriteView(presenter: favoritePresenter))
        
        let devProfileController = UINavigationController(rootViewController: DevProfileView(presenter: devProfilePresenter))
        
        gameListController.tabBarItem = UITabBarItem(title: "Gamelog", image: UIImage(systemName: "gamecontroller"), tag: 0)
        favoriteListController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), tag: 1)
        devProfileController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 3)
        
        viewControllers = [
            gameListController,
            favoriteListController,
            devProfileController
        ]
    }
}

