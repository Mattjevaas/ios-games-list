//
//  HomePresenter.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation
import RxSwift

protocol HomeViewDelegate: AnyObject {
    func beginCustomRefresh()
    func endCustomRefresh()
    func reloadCustomDataTable()
}

class HomeViewPresenter {
    
    private let disposeBag = DisposeBag()
    private let useCase: HomeUseCase
    private let router = HomeRouter()
    
    weak var delegate: HomeViewDelegate?
    weak var errordelegate: ErrorDelegate?
    
    var gameData: [GameModel] = []
    var gameDataFilter: [GameModel] = []
    
    var filterOn = false
    var dataSize = 10
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    func refreshData() {
        
        addDummy()
        
        self.delegate?.beginCustomRefresh()
        
        useCase.getGameData(pageSize: dataSize)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                
                self.gameData.removeAll()
                self.gameData.append(contentsOf: result)
            } onError: { error in
                self.errordelegate?.showError(msg: error.localizedDescription)
            } onCompleted: {
                
                self.delegate?.reloadCustomDataTable()
                self.delegate?.endCustomRefresh()
                self.dataSize = 10
            }.disposed(by: disposeBag)
    }
    
    func loadMoreData() {
        if gameData.count + 10 >= dataSize + 10 {
            
            addDummy()
            dataSize += 10
            
            loadData()
        } else {
            print("Reach End of line")
        }
    }
    
    func loadData() {
        
        self.delegate?.beginCustomRefresh()
        
        useCase.getGameData(pageSize: dataSize)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                
                self.gameData = result
            } onError: { error in
                self.errordelegate?.showError(msg: error.localizedDescription)
            } onCompleted: {
                
                self.delegate?.reloadCustomDataTable()
                self.delegate?.endCustomRefresh()
            }.disposed(by: disposeBag)
    }
    
    func addDummy() {
        for _ in 0..<10 {
            gameData.append(
                GameModel(
                    gameId: 0,
                    gameTitle: "Game Title",
                    gameRating: 0.0,
                    gameImage: "",
                    gameReleasedDate: "",
                    gameDesc: ""
                )
            )
        }

        self.delegate?.reloadCustomDataTable()
    }
    
    func makeGameDetailView(gameId: Int, gameTitle: String) -> GameDetailView {
        
        let gameDetailView = router.makeGameDetailView()
        gameDetailView.presenter.gameId = gameId
        gameDetailView.presenter.navTitle = gameTitle
        
        return gameDetailView
    }
}
