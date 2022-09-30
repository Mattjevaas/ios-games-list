//
//  RealmPersistance.swift
//  GameCatalog
//
//  Created by Admin on 30/09/22.
//

import RealmSwift

struct RealmPersistence {
    
    private var realm: Realm?
    
    init() {
        guard let realm = try? Realm() else { return }
        self.realm = realm
    }
    
    func saveData(object: Object) throws {
        do {
            try realm!.write {
                realm!.add(object)
            }
        } catch {
            throw CustomError.RealmError("Error while saving data")
        }
    }
    
    func deleteData(type: Object.Type, predicate: NSPredicate) throws {
        do {
            let data = realm!.objects(type).filter(predicate).first
            
            try realm!.write {
                realm!.delete(data!)
            }
        } catch {
            throw CustomError.RealmError("Error while deleting data")
        }
    }
    
    func fetchData<T>(type: T.Type) throws -> [T]? where T: Object {
        if realm != nil {
            let data = realm!.objects(type)
            return Array(data)
        } else {
            throw CustomError.RealmError("Error while fetching data")
        }
    }
    
    func isDataExist(type: Object.Type, predicate: NSPredicate) -> Bool {
        if realm != nil {
            let data = realm!.objects(type).filter(predicate).first
            
            if data != nil {
                return true
            }
        }
        
        return false
    }
}
