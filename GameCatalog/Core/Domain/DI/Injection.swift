//
//  Injection.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import RealmSwift
import Swinject

final class Injection: NSObject {
    private let container = Container()
    
    private override init() {}
    
    static let sharedInstance: Injection = Injection()
    
    func registerAll() {
        container.register(RemoteDataSourceProtocol.self) { _ in
            RemoteDataSource()
        }.inObjectScope(.container)
        
        container.register(LocaleDataSourceProtocol.self) { _ in
            let realm = try? Realm()
            return LocaleDataSource(realm: realm)
        }.inObjectScope(.container)
        
        container.register(GameRepositoryProtocol.self) { r in
            GameRepository(locale: r.resolve(LocaleDataSourceProtocol.self)!, remote: r.resolve(RemoteDataSourceProtocol.self)!)
        }.inObjectScope(.container)
        
        container.register(HomeUseCase.self) { r in
            HomeInteractor(repository: r.resolve(GameRepositoryProtocol.self)!)
        }
        
        container.register(GameDetailUseCase.self) { r in
            GameDetailInteractor(repository: r.resolve(GameRepositoryProtocol.self)!)
        }
        
        container.register(FavoriteUseCase.self) { r in
            FavoriteInteractor(repository: r.resolve(GameRepositoryProtocol.self)!)
        }
    }
    
    func provideFavoriteUC() -> FavoriteUseCase {
        let favUC = container.resolve(FavoriteUseCase.self)
        return favUC!
    }
    
    func provideHomeUC() -> HomeUseCase {
        let homeUC = container.resolve(HomeUseCase.self)
        return homeUC!
    }
    
    func provideGameDetailUC() -> GameDetailUseCase {
        let gameDetailUC = container.resolve(GameDetailUseCase.self)
        return gameDetailUC!
    }
}
