//
//  HomeView.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import UIKit
import Kingfisher

class HomeView: UIViewController {
    
    var tableView = UITableView()
    var refreshControl = UIRefreshControl()
    
    var presenter: HomeViewPresenter
    
    init(presenter: HomeViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Missing home presenter.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initilizeController()
        
        self.view.addSubview(tableView)
        
        setupTableView()
        setTableViewConstraints()
        setupRefreshController()
        
        presenter.refreshData()
    }
}

// MARK: - Init Setup
extension HomeView {
    
    func initilizeController() {
        view.backgroundColor = .white
        
        presenter.delegate = self
        presenter.errordelegate = self
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "Games List"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = search
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
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

// MARK: - Result Update Protocol
extension HomeView: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            presenter.gameDataFilter = presenter.gameData.filter { game in
                return game.gameTitle.lowercased().contains(text.lowercased())
            }
            
            presenter.filterOn = true
            
            if presenter.gameDataFilter.count == 0 {
                let label = UILabel()
                label.text = "Nothing Found"
                label.textColor = .systemGray
                label.textAlignment = .center
                
                tableView.backgroundView = label
            } else {
                tableView.backgroundView = nil
            }
        } else {
            presenter.filterOn = false
            tableView.backgroundView = nil
            presenter.gameDataFilter.removeAll()
        }
        
        tableView.reloadData()
    }
}

// MARK: - Table Delegate & Data Source
extension HomeView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = presenter.filterOn ? presenter.gameDataFilter[indexPath.row] : presenter.gameData[indexPath.row]
                                                                        
        let gameDetailView = presenter.makeGameDetailView(gameId: data.gameId, gameTitle: data.gameTitle)
        
        self.navigationController?.pushViewController(gameDetailView, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.filterOn ? presenter.gameDataFilter.count : presenter.gameData.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == presenter.gameData.count - 1 && !refreshControl.isRefreshing  && !presenter.filterOn {
            
            presenter.loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell else { return UITableViewCell() }
        
        cell.showAnimation()
        
        let data = presenter.filterOn ? presenter.gameDataFilter[indexPath.row] : presenter.gameData[indexPath.row]
        
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

// - MARK: Additional Function
extension HomeView {
    
    @objc func refreshData() {
        presenter.refreshData()
    }
}

// - MARK: Presenter Error Delegate
extension HomeView: ErrorDelegate {
    func showError(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alert, animated: true)
    }
}

// - MARK: Presenter HomeView Delegate
extension HomeView: HomeViewDelegate {
    func beginCustomRefresh() {
        refreshControl.beginRefreshing()
    }
    
    func endCustomRefresh() {
        refreshControl.endRefreshing()
    }
    
    func reloadCustomDataTable() {
        tableView.reloadData()
    }
}
