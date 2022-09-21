//
//  GameTableViewCell.swift
//  GameCatalog
//
//  Created by Admin on 15/09/22.
//

import UIKit
import SkeletonView

class GameTableViewCell: UITableViewCell {
    
    var gameImage = UIImageView()
    var gameTitle = UILabel()
    
    private var starImage = UIImageView()
    var gameRating = UILabel()
    var gameGenre = UILabel()
    var releasedDate = UILabel()
    
    var stackSecond = UIStackView()
    var stackFirst = UIStackView()
    var stackRating = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(gameImage)
        contentView.addSubview(stackSecond)
        
        configureGameImage()
        configureGameTitle()
        configureStarImage()
        configureGameRating()
        configureReleasedDate()
        
        setGameImageConstraints()
        setStarConstraints()
        setStarStack()
        setStackFirst()
        setStackSecond()
        setStackConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureGameImage() {
        gameImage.image = UIImage(named: "placeholder")
        gameImage.layer.cornerRadius = Constants.cellImageCorner
        gameImage.clipsToBounds = true
        gameImage.contentMode = .scaleAspectFill
    }
    
    func configureGameTitle() {
        gameTitle.text = "Game Title"
        gameTitle.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    func configureStarImage() {
        let icon = UIImage(systemName: "star.fill")
        starImage.image = icon
        starImage.tintColor = .systemYellow
    }
    
    func configureGameRating() {
        gameRating.text = "0.0"
        gameRating.font = UIFont.systemFont(ofSize: 13)
    }
    
    func configureReleasedDate() {
        releasedDate.text = "Released date:"
        releasedDate.font = UIFont.systemFont(ofSize: 13)
        releasedDate.textColor = .systemGray
    }
    
    func setGameImageConstraints() {
        gameImage.translatesAutoresizingMaskIntoConstraints = false
        gameImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        gameImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        gameImage.heightAnchor.constraint(equalToConstant: Constants.cellImageHeight).isActive = true
        gameImage.widthAnchor.constraint(equalToConstant: Constants.cellImageWidth).isActive = true
    }
    
    func setStarConstraints() {
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.heightAnchor.constraint(equalToConstant: 18).isActive = true
        starImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    func setStarStack() {
        stackRating.addArrangedSubview(starImage)
        stackRating.addArrangedSubview(gameRating)
        stackRating.spacing = 5
    }
    
    func setStackFirst() {
        stackFirst.addArrangedSubview(gameTitle)
        stackFirst.addArrangedSubview(stackRating)
        
        stackFirst.axis = .vertical
        stackFirst.spacing = 2
    }
    
    func setStackSecond() {
        stackSecond.addArrangedSubview(stackFirst)
        stackSecond.addArrangedSubview(releasedDate)
        stackSecond.axis = .vertical
        stackSecond.spacing = 20
    }
    
    func setStackConstraints() {
        stackSecond.translatesAutoresizingMaskIntoConstraints = false
        stackSecond.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackSecond.leadingAnchor.constraint(equalTo: gameImage.trailingAnchor, constant: 12).isActive = true
        stackSecond.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
    func showAnimation() {
        [ gameTitle, starImage, gameRating, releasedDate, stackFirst, stackRating, stackSecond].forEach {
            $0.isSkeletonable = true
            $0.showAnimatedSkeleton()
        }
        
        gameImage.isSkeletonable = true
        gameImage.showAnimatedSkeleton()
    }

    func hideAnimation() {
        gameImage.stopSkeletonAnimation()
        gameImage.hideSkeleton()

        [ gameTitle, starImage, gameRating, releasedDate, stackFirst, stackRating, stackSecond].forEach {
            $0.stopSkeletonAnimation()
            $0.hideSkeleton()
        }
    }
}
