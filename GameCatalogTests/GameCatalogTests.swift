//
//  GameCatalogTests.swift
//  GameCatalogTests
//
//  Created by admin on 07/11/22.
//

import XCTest
import RxSwift

@testable import GameCatalog
final class GameCatalogTests: XCTestCase {

    let injection = Injection.sharedInstance
    
    func testInjection() {
        injection.registerAll()
        XCTAssert(true)
    }
    
    func testProvideHomeUseCase() {
        let homeUC = injection.provideHomeUC()
        let state = homeUC is HomeUseCase
        
        XCTAssertEqual(true, state, "Failed to provide Home UseCase")
    }
    
    func testProvideGameDetailUseCase() {
        let gameDetailUC = injection.provideGameDetailUC()
        let state = gameDetailUC is GameDetailUseCase
        
        XCTAssertEqual(true, state, "Failed to provide GameDetail UseCase")
    }
    
    func testProvideFavoriteDetailUseCase() {
        let favUC = injection.provideFavoriteUC()
        let state = favUC is FavoriteUseCase
        
        XCTAssertEqual(true, state, "Failed to provide Favorite UseCase")
    }
    
    func testHomeUseCase() {
        
        let disposeBag = DisposeBag()
        
        var data: [GameModel] = []
        let homeUC = injection.provideHomeUC()
        
        homeUC.getGameData(pageSize: 10)
            .observe(on: MainScheduler.instance)
            .subscribe { result in

                data.append(contentsOf: result)
            } onError: { error in
                XCTAssertThrowsError(error)
            } onCompleted: {
                XCTAssertEqual(data.count, 10, "Failed to get game data")
            }.disposed(by: disposeBag)
    }
    
    func testGameDetailUseCase() {
        let disposeBag = DisposeBag()
        
        var data: GameModel?
        let gameUC = injection.provideGameDetailUC()
        
        gameUC.getGameDataDetail(idGame: 3498)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                data = result
            } onError: { error in
                XCTAssertThrowsError(error)
            } onCompleted: {
                XCTAssertEqual(data?.gameId, 3498, "Failed to get game detail data")
            }.disposed(by: disposeBag)
        
        let gameData: FavoriteGameModel = FavoriteGameModel(gameId: 3498, gameTitle: "test", gameRating: "test", gameImage: Data(), gameReleasedDate: "test", gameDesc: "test")
        
        gameUC.saveGameData(data: gameData)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                XCTAssertEqual(result, true, "Failed to save game detail data")
            } onError: { error in
                XCTAssertThrowsError(error)
            }.disposed(by: disposeBag)
        
        gameUC.isDataExsit(gameId: 3498)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                XCTAssertEqual(result, true, "Failed to get game detail data")
            } onError: { error in
                XCTAssertThrowsError(error)
            }.disposed(by: disposeBag)
        
        gameUC.getGameDataDetail(idGame: 3498)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                XCTAssertEqual(result.gameId, 3498, "Failed to get game detail data")
            } onError: { error in
                XCTAssertThrowsError(error)
            }.disposed(by: disposeBag)
        
        gameUC.deleteGameData(gameId: 3498)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                XCTAssertEqual(result, true, "Failed to delete game detail data")
            } onError: { error in
                XCTAssertThrowsError(error)
            }.disposed(by: disposeBag)
        
        gameUC.isDataExsit(gameId: 3498)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                XCTAssertEqual(result, false, "Failed to get game detail data")
            } onError: { error in
                XCTAssertThrowsError(error)
            }.disposed(by: disposeBag)
    }
}

