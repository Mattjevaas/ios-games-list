//
//  TabBarController.swift
//  GameCatalog
//
//  Created by Admin on 28/09/22.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameListController = UINavigationController(rootViewController: ViewController())
        let favoriteListController = UINavigationController(rootViewController: FavoriteViewController())
        let devProfileController = UINavigationController(rootViewController: DevProfileViewController())
        
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
