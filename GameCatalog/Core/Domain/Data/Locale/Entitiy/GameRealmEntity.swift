//
//  GameRealmEntity.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import RealmSwift

class GameRealmEntity: Object {
    @Persisted var gameId: Int
    @Persisted var gameTitle: String
    @Persisted var gameRating: String
    @Persisted var gameImage: Data
    @Persisted var gameReleasedDate: String
    @Persisted var gameDesc: String
}
