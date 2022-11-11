//
//  GameDetailInteractor.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation
import RxSwift

protocol GameDetailUseCase {
    func getGameDataDetail(idGame: Int) -> Observable<GameModel>
    func saveGameData(data: FavoriteGameModel) -> Observable<Bool>
    func deleteGameData(gameId: Int) -> Observable<Bool>
    func isDataExsit(gameId: Int) -> Observable<Bool>
}

class GameDetailInteractor: GameDetailUseCase {
    
    private let repository: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getGameDataDetail(idGame: Int) -> RxSwift.Observable<GameModel> {
        return repository.getGameDataDetail(idGame: idGame)
    }
    
    func saveGameData(data: FavoriteGameModel) -> Observable<Bool> {
        return repository.saveGameData(data: data)
    }
    
    func deleteGameData(gameId: Int) -> Observable<Bool> {
        return repository.deleteGameData(gameId: gameId)
    }
    
    func isDataExsit(gameId: Int) -> RxSwift.Observable<Bool> {
        return repository.isDataExist(gameId: gameId)
    }
    
}
