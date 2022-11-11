//
//  HomeRouter.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation

class HomeRouter {
    
    func makeGameDetailView() -> GameDetailView {
        let gameDetailUC = Injection.sharedInstance
        let gameDetailPresenter = GameDetailPresenter(useCase: gameDetailUC.provideGameDetailUC())
        
        return GameDetailView(presenter: gameDetailPresenter)
    }
}
