//
//  FavoriteViewController.swift
//  GameCatalog
//
//  Created by Admin on 28/09/22.
//

import UIKit
import Kingfisher
import RealmSwift

class FavoriteViewController: UIViewController {
    
    var favGames: [FavoriteGameData] = []
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initilizeController()
        self.view.addSubview(tableView)
        
        setupTableView()
        setTableViewConstraints()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        
        if favGames.count == 0 {
            let label = UILabel()
            label.text = "Nothing to show"
            label.textColor = .systemGray
            label.textAlignment = .center
            
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
    }
}

// MARK: - Init Setup
extension FavoriteViewController {
    func initilizeController() {
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Favorite Games"
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: "GameCell")
        tableView.rowHeight = 150
    }
    
    func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func loadData() {
        guard let realm = try? Realm() else { return }
        
        let data = realm.objects(GameDataRealm.self)
        favGames = data.map { result in
            return FavoriteGameData(
                gameId: result.gameId,
                gameTitle: result.gameTitle,
                gameRating: result.gameRating,
                gameImage: result.gameImage,
                gameReleasedDate: result.gameReleasedDate,
                gameDesc: result.gameDesc
            )
        }
        
        tableView.reloadData()
    }
}

// MARK: - Additional Functions
extension FavoriteViewController {
    func showError(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

// MARK: - Table Delegate & Data Source
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = favGames[indexPath.row]
                                                                           
        let gameDetailController = GameDetailViewController()
        gameDetailController.gameId = data.gameId
        gameDetailController.navTitle = data.gameTitle
        
        self.navigationController?.pushViewController(gameDetailController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell else { return UITableViewCell() }
        
        cell.showAnimation()
        
        let data = favGames[indexPath.row]
        
        cell.gameImage.image = UIImage(data: data.gameImage)
        cell.gameTitle.text = data.gameTitle
        cell.gameRating.text = String(data.gameRating)
        cell.releasedDate.text = "Released date: \(data.gameReleasedDate)"
        
        if cell.gameTitle.text != "Game Title" {
            cell.hideAnimation()
        }
        
        return cell
    }
}
