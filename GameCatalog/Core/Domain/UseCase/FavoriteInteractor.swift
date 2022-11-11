//
//  FavoriteInteractor.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation
import RxSwift

protocol FavoriteUseCase {
    func fetchData() -> Observable<[FavoriteGameModel]>
}

class FavoriteInteractor: FavoriteUseCase {
    
    private let repository: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchData() -> Observable<[FavoriteGameModel]> {
        return repository.fetchData()
    }
}
