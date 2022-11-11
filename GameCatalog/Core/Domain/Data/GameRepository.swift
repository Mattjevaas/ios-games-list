//
//  GameRepository.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation
import RxSwift
import RealmSwift

protocol GameRepositoryProtocol {
    func getGameData(pageSize: Int) -> Observable<[GameModel]>
    func getGameDataDetail(idGame: Int) -> Observable<GameModel>
    func saveGameData(data: FavoriteGameModel) -> Observable<Bool>
    func deleteGameData(gameId: Int) -> Observable<Bool>
    func isDataExist(gameId: Int) -> Observable<Bool>
    func fetchData() -> Observable<[FavoriteGameModel]>
}

final class GameRepository: GameRepositoryProtocol {
    
    fileprivate let remote: RemoteDataSourceProtocol
    fileprivate let locale: LocaleDataSourceProtocol
    
    init(locale: LocaleDataSourceProtocol, remote: RemoteDataSourceProtocol) {
        self.remote = remote
        self.locale = locale
    }
    
    func getGameData(pageSize: Int) -> Observable<[GameModel]> {
        return self.remote.getGameData(pageSize: pageSize).map { result in
            
            var gameModel: [GameModel] = []
            
            if let res = result.results {
                gameModel = res.map { data in
                    
                    var fixedDate = "unknown"
                    
                    let formatterOne = DateFormatter()
                    formatterOne.dateFormat = "yyyy-mm-dd"

                    let formatterTwo = DateFormatter()
                    formatterTwo.dateFormat = "dd-mm-yyyy"

                    if let dateOne = formatterOne.date(from: data.released ?? "") {
                        fixedDate = formatterTwo.string(from: dateOne)
                    }
                    
                    return GameModel(
                        gameId: data.id ?? 0,
                        gameTitle: data.name ?? "",
                        gameRating: Float(data.rating ?? 0.0),
                        gameImage: data.backgroundImage ?? "",
                        gameReleasedDate: fixedDate,
                        gameDesc: ""
                    )
                }
            }
            
            return gameModel
        }
    }
    
    func getGameDataDetail(idGame: Int) -> Observable<GameModel> {
        return self.remote.getGameDataDetail(idGame: idGame).map { result in
            var fixedDate = "unknown"
                    
            let formatterOne = DateFormatter()
            formatterOne.dateFormat = "yyyy-mm-dd"

            let formatterTwo = DateFormatter()
            formatterTwo.dateFormat = "dd-mm-yyyy"

            if let dateOne = formatterOne.date(from: result.released ?? "") {
                fixedDate = formatterTwo.string(from: dateOne)
            }
            
            return GameModel(
                gameId: result.id ?? 0,
                gameTitle: result.nameOriginal ?? "",
                gameRating: Float(result.rating ?? 0.0),
                gameImage: result.backgroundImage ?? "",
                gameReleasedDate: fixedDate,
                gameDesc: result.descriptionRaw ?? ""
            )
        }
    }
    
    func saveGameData(data: FavoriteGameModel) -> Observable<Bool> {
        let gameData = GameRealmEntity()
        
        gameData.gameId = data.gameId
        gameData.gameTitle = data.gameTitle
        gameData.gameRating = data.gameRating
        gameData.gameDesc = data.gameDesc
        gameData.gameReleasedDate = data.gameReleasedDate
        gameData.gameImage = data.gameImage
        
        return self.locale.saveData(object: gameData)
    }
    
    func deleteGameData(gameId: Int) -> Observable<Bool> {
        return self.locale.deleteData(type: GameRealmEntity.self, predicate: NSPredicate(format: "gameId == \(gameId)"))
    }
    
    func isDataExist(gameId: Int) -> Observable<Bool> {
        return self.locale.isDataExist(type: GameRealmEntity.self, predicate: NSPredicate(format: "gameId == \(gameId)"))
    }
    
    func fetchData() -> Observable<[FavoriteGameModel]> {
        return self.locale.fetchData(type: GameRealmEntity.self).map { result in
            
            var gameArr: [FavoriteGameModel] = []
            
            result.forEach { data in
                
                let favGameModel = FavoriteGameModel(
                    gameId: data.gameId,
                    gameTitle: data.gameTitle,
                    gameRating: data.gameRating,
                    gameImage: data.gameImage,
                    gameReleasedDate: data.gameReleasedDate,
                    gameDesc: data.gameDesc
                )
                
                gameArr.append(favGameModel)
            }
            
            return gameArr
        }
        
    }
}

