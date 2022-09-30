//
//  GameNetwork.swift
//  GameCatalog
//
//  Created by Admin on 16/09/22.
//
import UIKit

protocol ErrorNetworkDelegate: AnyObject {
    func showErrorMessage(msg: String)
}

class GameNetwork {
    
    weak var delegate: ErrorNetworkDelegate?
    
    private var apiKey: String {
        get {
          
            guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
              return ""
            }

            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                return ""
            }
              
            return value
        }
    }
    
    private let session = URLSession(configuration: .default)
    
    func getGameData(pageSize: Int) async throws -> [GameData] {
        
        var component = URLComponents(string: "https://api.rawg.io/api/games")!
        
        component.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "page_size", value: String(pageSize))
        
        ]
        
        let request = URLRequest(url: (component.url)!)
        
        let (data, response) = try await session.data(for: request)
        
        guard (response as? HTTPURLResponse)!.statusCode == 200 else {
            delegate?.showErrorMessage(msg: "Failed to load data from network")
            throw CustomError.NetworkError("Failed to load data from network")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(GameResponse.self, from: data)
        
        var gameData: [GameData] = []
        
        if let res = result.results {
            gameData = res.map { data in
                
                var fixedDate = "unknown"
                
                let formatterOne = DateFormatter()
                formatterOne.dateFormat = "yyyy-mm-dd"

                let formatterTwo = DateFormatter()
                formatterTwo.dateFormat = "dd-mm-yyyy"

                if let dateOne = formatterOne.date(from: data.released ?? "") {
                    fixedDate = formatterTwo.string(from: dateOne)
                }
                
                return GameData(
                        gameId: data.id ?? 0,
                        gameTitle: data.name ?? "",
                        gameRating: Float(data.rating ?? 0.0),
                        gameImage: data.backgroundImage ?? "",
                        gameReleasedDate: fixedDate,
                        gameDesc: ""
                    )
            }
        }
        
        return gameData
    }
    
    func getGameDataDetail(idGame: Int) async throws -> GameData {
        
        var component = URLComponents(string: "https://api.rawg.io/api/games/\(idGame)")!
        
        component.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        let request = URLRequest(url: (component.url)!)
        
        let (data, response) = try await session.data(for: request)
        
        guard (response as? HTTPURLResponse)!.statusCode == 200 else {
            delegate?.showErrorMessage(msg: "Failed to load data from network")
            throw CustomError.NetworkError("Failed to load data from network")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(GameDetailResponse.self, from: data)
        
        var fixedDate = "unknown"
        
        let formatterOne = DateFormatter()
        formatterOne.dateFormat = "yyyy-mm-dd"

        let formatterTwo = DateFormatter()
        formatterTwo.dateFormat = "dd-mm-yyyy"

        if let dateOne = formatterOne.date(from: result.released ?? "") {
            fixedDate = formatterTwo.string(from: dateOne)
        }
        return GameData(
                gameId: result.id ?? 0,
                gameTitle: result.nameOriginal ?? "",
                gameRating: Float(result.rating ?? 0.0),
                gameImage: result.backgroundImage ?? "",
                gameReleasedDate: fixedDate,
                gameDesc: result.descriptionRaw ?? ""
            )
    }
}
