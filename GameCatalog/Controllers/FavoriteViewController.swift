//
//  FavoriteViewController.swift
//  GameCatalog
//
//  Created by Admin on 28/09/22.
//

import UIKit
import Kingfisher

class FavoriteViewController: UIViewController {
    
    var gameData: [GameData] = []
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initilizeController()
        
        self.view.addSubview(tableView)
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
}

// MARK: - Table Delegate & Data Source
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = gameData[indexPath.row]
                                                                           
        let gameDetailController = GameDetailViewController()
        gameDetailController.gameId = data.gameId
        gameDetailController.navTitle = data.gameTitle
        
        self.navigationController?.pushViewController(gameDetailController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell else { return UITableViewCell() }
        
        cell.showAnimation()
        
        let data = gameData[indexPath.row]
        
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
