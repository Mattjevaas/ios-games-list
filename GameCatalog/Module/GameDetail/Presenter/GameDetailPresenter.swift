//
//  GameDetailPresenter.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation
import Kingfisher
import RxSwift

protocol GameDetailDelegate: AnyObject {
    
    func loadDataFromResult(result: GameModel)
    func changeButton(buttonName: String)
    func showCustomAnimation()
    func hideCustomAnimation()
}

class GameDetailPresenter {
    
    private let disposeBag = DisposeBag()
    private let useCase: GameDetailUseCase
    
    weak var delegate: GameDetailDelegate?
    weak var errordelegate: ErrorDelegate?
    
    var gameId: Int?
    var navTitle: String?
    var isFavorite: Bool = false
    
    init(useCase: GameDetailUseCase) {
        self.useCase = useCase
    }
    
    func loadData(id: Int) {
        
        self.delegate?.showCustomAnimation()

        useCase.getGameDataDetail(idGame: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.delegate?.loadDataFromResult(result: result)
            } onError: { error in
                self.errordelegate?.showError(msg: error.localizedDescription)
            } onCompleted: {
                self.delegate?.hideCustomAnimation()
            }.disposed(by: disposeBag)
    }
    
    func initFavoriteButton() {
        
        useCase.isDataExsit(gameId: gameId!)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                
                var buttonName = ""
                
                if result {
                    buttonName = "heart.fill"
                    self.isFavorite = true
                } else {
                    buttonName = "heart"
                }
                
                self.delegate?.changeButton(buttonName: buttonName)
            } onError: { error in
                self.errordelegate?.showError(msg: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    func saveGameData(gameData: FavoriteGameModel) {
        
        useCase.saveGameData(data: gameData)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                if result {
                    self.isFavorite = !self.isFavorite
                    
                    self.delegate?.changeButton(buttonName: self.isFavorite ? "heart.fill" : "heart")
                }
            } onError: { error in
                self.errordelegate?.showError(msg: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    func deleteGameData() {
        useCase.deleteGameData(gameId: gameId!)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                if result {
                    self.isFavorite = !self.isFavorite
                    
                    self.delegate?.changeButton(buttonName: self.isFavorite ? "heart.fill" : "heart")
                }
            } onError: { error in
                self.errordelegate?.showError(msg: error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
}

