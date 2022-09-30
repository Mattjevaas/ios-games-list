//
//  ViewController.swift
//  GameCatalog
//
//  Created by Admin on 15/09/22.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    var gameNetwork = GameNetwork()
    var gameData: [GameData] = []
    var gameDataFilter: [GameData] = []
    
    var filterOn = false
    var dataSize = 10

    var tableView = UITableView()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initilizeController()
        
        self.view.addSubview(tableView)
        setupTableView()
        setTableViewConstraints()
        setupRefreshController()
        
        refreshData()
    }
}

// MARK: - Init Setup
extension ViewController {
    
    func initilizeController() {
        view.backgroundColor = .white
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Games List"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = search
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        gameNetwork.delegate = self

        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: "GameCell")
        tableView.rowHeight = 150
    }
    
    func setupRefreshController() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

// MARK: - Additional Functions
extension ViewController {
    
    @objc func refreshData() {
        addDummy()
        
        Task {
            refreshControl.beginRefreshing()
            
            do {
                gameData = try await gameNetwork.getGameData(pageSize: dataSize)
                tableView.reloadData()
            } catch {
                showError(msg: "Cannot load data from network")
            }
            
            refreshControl.endRefreshing()
            dataSize = 10
        }
    }
    
    func loadMoreData() {
        if gameData.count + 10 >= dataSize + 10 {
            
            addDummy()
            dataSize += 10
            
            Task {
                refreshControl.beginRefreshing()
                
                do {
                    gameData = try await gameNetwork.getGameData(pageSize: dataSize)
                    tableView.reloadData()
                } catch {
                    showError(msg: "Cannot load data from network")
                }
                
                refreshControl.endRefreshing()
            }
        } else {
            print("Reach End of line")
        }
    }
    
    func addDummy() {
        for _ in 0..<10 {
            gameData.append(
                GameData(
                    gameId: 0,
                    gameTitle: "Game Title",
                    gameRating: 0.0,
                    gameImage: "",
                    gameReleasedDate: "",
                    gameDesc: ""
                )
            )
        }
        
        tableView.reloadData()
    }
    
    func showError(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

// MARK: - Result Update Protocol
extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            gameDataFilter = gameData.filter { game in
                return game.gameTitle.lowercased().contains(text.lowercased())
            }
            
            filterOn = true
            
            if gameDataFilter.count == 0 {
                let label = UILabel()
                label.text = "Nothing Found"
                label.textColor = .systemGray
                label.textAlignment = .center
                
                tableView.backgroundView = label
            } else {
                tableView.backgroundView = nil
            }
        } else {
            filterOn = false
            tableView.backgroundView = nil
            gameDataFilter.removeAll()
        }
        
        tableView.reloadData()
    }
}

// MARK: - Table Delegate & Data Source
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = filterOn ? gameDataFilter[indexPath.row] : gameData[indexPath.row]
                                                                           
        let gameDetailController = GameDetailViewController()
        gameDetailController.gameId = data.gameId
        gameDetailController.navTitle = data.gameTitle
        
        self.navigationController?.pushViewController(gameDetailController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOn ? gameDataFilter.count : gameData.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == gameData.count - 1 && !refreshControl.isRefreshing  && !filterOn {
            loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell else { return UITableViewCell() }
        
        cell.showAnimation()
        
        let data = filterOn ? gameDataFilter[indexPath.row] : gameData[indexPath.row]
        
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: Constants.cellImageWidth, height: Constants.cellImageHeight), mode: .aspectFill) |> RoundCornerImageProcessor(cornerRadius: Constants.cellImageCorner)

        cell.gameImage.kf.indicatorType = .activity
        cell.gameImage.kf.setImage(
            with: URL(string: data.gameImage),
            options: [
                .processor(processor),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )

        cell.gameTitle.text = data.gameTitle
        cell.gameRating.text = String(data.gameRating)
        cell.releasedDate.text = "Released date: \(data.gameReleasedDate)"
        
        if cell.gameTitle.text != "Game Title" {
            cell.hideAnimation()
        }
        
        return cell
    }
}

// MARK: - Error Network Delegate
extension ViewController: ErrorNetworkDelegate {
    func showErrorMessage(msg: String) {
        DispatchQueue.main.async {
            self.showError(msg: msg)
        }
    }
}
