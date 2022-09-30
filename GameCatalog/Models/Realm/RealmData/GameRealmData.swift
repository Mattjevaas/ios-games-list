//
//  GameDataRealm.swift
//  GameCatalog
//
//  Created by Admin on 28/09/22.
//

import RealmSwift

class GameRealmData: Object {
    @Persisted var gameId: Int
    @Persisted var gameTitle: String
    @Persisted var gameRating: String
    @Persisted var gameImage: Data
    @Persisted var gameReleasedDate: String
    @Persisted var gameDesc: String
}
