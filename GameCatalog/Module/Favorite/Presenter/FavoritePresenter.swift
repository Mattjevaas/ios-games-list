//
//  FavoritePresenter.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation

import Foundation
import RxSwift

class FavoritePresenter {
    
    private let useCase: FavoriteUseCase
    private let disposeBag = DisposeBag()
    private let router = FavoriteRouter()
    
    var delegate: ErrorDelegate?
    
    var favGames: [FavoriteGameModel] = []
    var tableView = UITableView()
    
    init(useCase: FavoriteUseCase) {
        self.useCase = useCase
    }
    
    func loadData() {
        
        useCase.fetchData()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.favGames = result
            } onError: { error in
                self.delegate?.showError(msg: error.localizedDescription)
            } onCompleted: {
                self.tableView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    func goToGameDetail(gameId: Int, gameTitle: String) -> GameDetailView {
        let gameDetailView = router.makeGameDetailView()
        gameDetailView.presenter.gameId = gameId
        gameDetailView.presenter.navTitle = gameTitle
        
        return gameDetailView
    }
}
