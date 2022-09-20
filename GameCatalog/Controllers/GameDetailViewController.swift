//
//  GameDetailViewController.swift
//  GameCatalog
//
//  Created by Admin on 20/09/22.
//

import UIKit
import SkeletonView
import Kingfisher

class GameDetailViewController: UIViewController {

    var gameId: Int?
    var navTitle: String?
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    
    private var gameImage = UIImageView()
    private var gameTitle = UILabel()
    private var gameRating = UILabel()
    private var gameDesc = UILabel()
    private var gameReleased = UILabel()
    
    private var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initilizeController()
        showAnimation()
        
        if let id = gameId {
            Task {
                await loadData(id: id)
                hideAnimation()
            }
        }
    }
}

// MARK: - Init Setup
extension GameDetailViewController {
    
    func initilizeController() {
        
        view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
    
        self.navigationItem.title = navTitle ?? "Game Detail"
        
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

// MARK: - Additional Functions
extension GameDetailViewController {
    
    func loadData(id: Int) async {
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: Constants.cellImageWidth, height: Constants.cellImageHeight), mode: .aspectFill) |> RoundCornerImageProcessor(cornerRadius: Constants.cellImageCorner)
        
        do {
            let network = GameNetwork()
            let data = try await network.getGameDataDetail(idGame: id)
            
            gameImage.kf.indicatorType = .activity
            gameImage.kf.setImage(
                with: URL(string: data.gameImage),
                options: [
                    .processor(processor),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]
            )
            
            gameTitle.text = "Title: \(data.gameTitle)"
            gameRating.text = "Rating: \(data.gameRating)"
            gameDesc.text = "Description: \n\n\(data.gameDesc)"
            gameReleased.text = "Released date: \(data.gameReleasedDate)"
            
        } catch {
            print("Something wrong")
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
