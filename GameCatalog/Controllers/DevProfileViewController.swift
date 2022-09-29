//
//  DevProfileViewController.swift
//  GameCatalog
//
//  Created by Admin on 21/09/22.
//

import UIKit

class DevProfileViewController: UIViewController {
    
    private var devImage = UIImageView()
    private var devName = UILabel()
    private var devDesc = UILabel()
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    
    private var stack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeController()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(devImage)
        contentView.addSubview(stack)
        
        configureDevImage()
        configureLabel()
        setStack()
        setScrollViewConstraints()
        setContentViewConstraints()
        setDevImageConstraints()
        setStackConstraints()
    }
}

extension DevProfileViewController {
    
    func initializeController() {
        view.backgroundColor = .white
        self.navigationItem.title = "Developer Profile"
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureDevImage() {
        devImage.image = UIImage(named: "devimage")
        devImage.layer.cornerRadius = Constants.cellImageCorner
        devImage.layer.borderWidth = 5
        devImage.clipsToBounds = true
        devImage.contentMode = .scaleAspectFill
    }
    
    func configureLabel() {
        devName.text = "Johanes Wiku Sakti"
        devName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        devName.textAlignment = .center
        
        devDesc.text = "Passionate in Computer Science with a focus on web and mobile application development. Interested in learning new things especially about programming, entrepreneurship, and technology. A person who love to make new connection with others to share experiences with each other."
        devDesc.font = UIFont.systemFont(ofSize: 14)
        devDesc.numberOfLines = 0
        devDesc.textAlignment = .justified
    }
    
    func setStack() {
        stack.addArrangedSubview(devName)
        stack.addArrangedSubview(devDesc)
        
        stack.spacing = 30
        stack.axis = .vertical
        stack.alignment = .fill
    }
    
    func setScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    }
    
    func setContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    func setDevImageConstraints() {
        devImage.translatesAutoresizingMaskIntoConstraints = false
        devImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        devImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        devImage.widthAnchor.constraint(equalToConstant: Constants.detailImageWidth).isActive = true
        devImage.heightAnchor.constraint(equalToConstant: Constants.detailImageHeight).isActive = true
    }
    
    func setStackConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: devImage.bottomAnchor, constant: 20).isActive = true
        stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
