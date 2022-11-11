//
//  GameDataMapper.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation

struct GameDataMapper {
    static func mapGameResponseToDomains(result: GameResponse) -> [GameModel] {
        var gameModel: [GameModel] = []
        
        if let res = result.results {
            gameModel = res.map { data in
                
                return GameModel(
                    gameId: data.id ?? 0,
                    gameTitle: data.name ?? "",
                    gameRating: Float(data.rating ?? 0.0),
                    gameImage: data.backgroundImage ?? "",
                    gameReleasedDate: CustomDateFormatter.formatDate(date: data.released ?? "0"),
                    gameDesc: ""
                )
            }
        }
        
        return gameModel
    }
    
    static func mapGameDetailResponseToDomain(result: GameDetailResponse) -> GameModel {
        
        return GameModel(
            gameId: result.id ?? 0,
            gameTitle: result.nameOriginal ?? "",
            gameRating: Float(result.rating ?? 0.0),
            gameImage: result.backgroundImage ?? "",
            gameReleasedDate: CustomDateFormatter.formatDate(date: result.released ?? "0"),
            gameDesc: result.descriptionRaw ?? ""
        )
    }
}
