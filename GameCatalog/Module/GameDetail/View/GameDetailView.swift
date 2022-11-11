//
//  GameDetailView.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import UIKit
import SkeletonView
import Kingfisher
import RxSwift

class GameDetailView: UIViewController {
    
    var presenter: GameDetailPresenter
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    var gameImage = UIImageView()
    var gameTitle = UILabel()
    var gameRating = UILabel()
    var gameDesc = UILabel()
    var gameReleased = UILabel()
    
    var stackView = UIStackView()
    
    init(presenter: GameDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Missing game detail presenter.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initilizeController()
        
        if let id = presenter.gameId {
            presenter.loadData(id: id)
        }
    }
}

// MARK: - Init Setup
extension GameDetailView {
    
    func initilizeController() {
        
        presenter.errordelegate = self
        presenter.delegate = self
        
        view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.navigationItem.title = presenter.navTitle ?? "Game Detail"
        presenter.initFavoriteButton()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(gameImage)
        contentView.addSubview(stackView)
        
        configureGameImage()
        configureLabel()
        
        setScrollViewConstraints()
        setContentViewConstraints()
        setStack()
        setGameImageConstraints()
        setStackConstraints()
    
    }
    
    func configureGameImage() {
        gameImage.image = UIImage(named: "placeholder")
        gameImage.layer.cornerRadius = Constants.cellImageCorner
        gameImage.clipsToBounds = true
        gameImage.contentMode = .scaleAspectFill
    }
    
    func configureLabel() {
        gameTitle.text = "Title: "
        gameTitle.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        gameRating.text = "Rating: "
        gameRating.font = UIFont.systemFont(ofSize: 14)
        
        gameDesc.text = "Description: "
        gameDesc.font = UIFont.systemFont(ofSize: 14)
        gameDesc.numberOfLines = 0
        gameDesc.textAlignment = .justified
        
        gameReleased.text = "Released date: "
        gameReleased.font = UIFont.systemFont(ofSize: 14)
        gameReleased.textColor = .systemGray
    }
    
    func setStack() {
        stackView.addArrangedSubview(gameTitle)
        stackView.addArrangedSubview(gameRating)
        stackView.addArrangedSubview(gameDesc)
        stackView.addArrangedSubview(gameReleased)
        
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .fill
    }
    
    func setScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    func setContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    func setGameImageConstraints() {
        gameImage.translatesAutoresizingMaskIntoConstraints = false
        gameImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        gameImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        gameImage.widthAnchor.constraint(equalToConstant: Constants.detailImageWidth).isActive = true
        gameImage.heightAnchor.constraint(equalToConstant: Constants.detailImageHeight).isActive = true
    }
    
    func setStackConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 50).isActive = true
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

extension GameDetailView {
    
    @objc func onClickFavorite() {
        
        if !presenter.isFavorite {
            
            let gameData = FavoriteGameModel(
                gameId: presenter.gameId!,
                gameTitle: gameTitle.text!,
                gameRating: gameRating.text!,
                gameImage: gameImage.image!.pngData()!,
                gameReleasedDate: gameReleased.text!,
                gameDesc: gameDesc.text!
            )
            
            presenter.saveGameData(gameData: gameData)
            
        } else {
            presenter.deleteGameData()
        }
    }
    
    func showAnimation() {
        [gameTitle, gameRating, gameDesc, gameReleased].forEach {
            $0.isSkeletonable = true
            $0.showAnimatedSkeleton()
        }
        
        gameImage.isSkeletonable = true
        gameImage.showAnimatedSkeleton()
    }
    
    func hideAnimation() {
        gameImage.stopSkeletonAnimation()
        gameImage.hideSkeleton()

        [gameTitle, gameRating, gameDesc, gameReleased].forEach {
            $0.stopSkeletonAnimation()
            $0.hideSkeleton()
        }
    }
}

// MARK: - Error Delegate
extension GameDetailView: ErrorDelegate {
    
    func showError(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alert, animated: true)
    }
}

// MARK: - Error Delegate
extension GameDetailView: GameDetailDelegate {
    
    func changeButton(buttonName: String) {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: buttonName),
            style: .plain,
            target: self,
            action: #selector(onClickFavorite)
        )
    }
    
    func showCustomAnimation() {
        showAnimation()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func hideCustomAnimation() {
        self.hideAnimation()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func loadDataFromResult(result: GameModel) {
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: Constants.cellImageWidth, height: Constants.cellImageHeight), mode: .aspectFill) |> RoundCornerImageProcessor(cornerRadius: Constants.cellImageCorner)
        
        self.gameImage.kf.indicatorType = .activity
        self.gameImage.kf.setImage(
            with: URL(string: result.gameImage),
            options: [
                .processor(processor),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        
        self.gameTitle.text = "Title: \(result.gameTitle)"
        self.gameRating.text = "Rating: \(result.gameRating)"
        self.gameDesc.text = "Description: \n\n\(result.gameDesc)"
        self.gameReleased.text = "Released date: \(result.gameReleasedDate)"
    }
}
