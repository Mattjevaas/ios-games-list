//
//  RealmDatasource.swift
//  GameCatalog
//
//  Created by Admin on 29/09/22.
//

import RealmSwift

class RealmDatasource {
    
    private var realm: Realm?
    
    init() {
        guard let realm = try? Realm() else { return }
        self.realm = realm
    }
    
    func saveData(data: GameDataRealm) throws {
        
        do {
            try realm!.write {
                realm!.add(data)
            }
        } catch {
            throw CustomError.RealmError("Error while saving data")
        }
    }
    
    func deleteData(id: Int) throws {
        
        do {
            let data = realm!.objects(GameDataRealm.self).where {
                $0.gameId == id
            }.first!
            
            try realm!.write {
                realm!.delete(data)
            }
        } catch {
            throw CustomError.RealmError("Error while deleting data")
        }
    }
    
    func getAllData() throws -> [FavoriteGameData] {
        
        if realm != nil {
            let data = realm!.objects(GameDataRealm.self)
            let favGames: [FavoriteGameData] = data.map { result in
                return FavoriteGameData(
                    gameId: result.gameId,
                    gameTitle: result.gameTitle,
                    gameRating: result.gameRating,
                    gameImage: result.gameImage,
                    gameReleasedDate: result.gameReleasedDate,
                    gameDesc: result.gameDesc
                )
            }
            
            return favGames
        } else {
            throw CustomError.RealmError("Error while getting data")
        }
    }
}
