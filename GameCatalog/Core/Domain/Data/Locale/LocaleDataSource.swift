//
//  LocaleDataSource.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import RealmSwift
import RxSwift

protocol LocaleDataSourceProtocol: AnyObject {
    func saveData(object: Object) -> Observable<Bool>
    func deleteData(type: Object.Type, predicate: NSPredicate) -> Observable<Bool>
    func fetchData<T>(type: T.Type) -> Observable<[T]> where T: Object
    func isDataExist(type: Object.Type, predicate: NSPredicate) -> Observable<Bool>
}

final class LocaleDataSource: LocaleDataSourceProtocol {
    
    private var realm: Realm?
    
    init(realm: Realm?) {
        self.realm = realm
    }
    
    func saveData(object: Object) -> Observable<Bool> {
        
        return Observable<Bool>.create { observer in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.add(object)
                        
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(DatabaseError.requestFailed)
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            
            return Disposables.create()
        }
    }
    
    func deleteData(type: Object.Type, predicate: NSPredicate) -> Observable<Bool> {
        
        return Observable<Bool>.create { observer in
            if let realm = self.realm {
                do {
                    
                    let data = realm.objects(type).filter(predicate).first
                    
                    try realm.write {
                        realm.delete(data!)
                        
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(DatabaseError.requestFailed)
                }
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            
            return Disposables.create()
        }
    }
    
    func fetchData<T>(type: T.Type) -> Observable<[T]> where T: Object {
        
        return Observable<[T]>.create { observer in
            if let realm = self.realm {
                
                let data = realm.objects(type)
        
                observer.onNext(Array(data))
                observer.onCompleted()
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            
            return Disposables.create()
        }
    }
    
    func isDataExist(type: Object.Type, predicate: NSPredicate) -> Observable<Bool> {
        
        return Observable<Bool>.create { observer in
            if let realm = self.realm {
                
                let data = realm.objects(type).filter(predicate).first
                
                if data != nil {
                    observer.onNext(true)
                    observer.onCompleted()
                }
                
                observer.onNext(false)
                observer.onCompleted()
                
            } else {
                observer.onError(DatabaseError.invalidInstance)
            }
            
            return Disposables.create()
        }
    }
}
