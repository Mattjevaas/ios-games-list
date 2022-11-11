//
//  HomeInteractor.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation
import RxSwift

protocol HomeUseCase {
    func getGameData(pageSize: Int) -> Observable<[GameModel]>
}

class HomeInteractor: HomeUseCase {
    
    private let repository: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func getGameData(pageSize: Int) -> RxSwift.Observable<[GameModel]> {
        return repository.getGameData(pageSize: pageSize)
    }
}
