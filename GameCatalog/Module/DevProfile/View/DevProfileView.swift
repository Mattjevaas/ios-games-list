//
//  DevProfileView.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import UIKit

class DevProfileView: UIViewController {
    
    var presenter: DevProfilePresenter
    
    init(presenter: DevProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Missing dev profile presenter.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeController()
        
        view.addSubview(presenter.scrollView)
        presenter.scrollView.addSubview(presenter.contentView)
        presenter.contentView.addSubview(presenter.devImage)
        presenter.contentView.addSubview(presenter.stack)
        
        configureDevImage()
        configureLabel()
        setStack()
        setScrollViewConstraints()
        setContentViewConstraints()
        setDevImageConstraints()
        setStackConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.initProfileData()
    }
}

// MARK: - Init Setup
extension DevProfileView {
    
    func initializeController() {
        view.backgroundColor = .white
        presenter.view = self
        self.navigationItem.title = "Developer Profile"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(presenter.goToEditProfile)
        )
    }
    
    @objc func goToEditProfile() {
        
        let editProfileView = presenter.makeEditProfileView()
        self.navigationController?.pushViewController(editProfileView, animated: true)
    }
    
    func configureDevImage() {
        presenter.devImage.image = UIImage(named: "devimage")
        presenter.devImage.layer.cornerRadius = Constants.cellImageCorner
        presenter.devImage.layer.borderWidth = 5
        presenter.devImage.clipsToBounds = true
        presenter.devImage.contentMode = .scaleAspectFill
    }
    
    func configureLabel() {
        presenter.devName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        presenter.devName.textAlignment = .center
        
        presenter.devDesc.font = UIFont.systemFont(ofSize: 14)
        presenter.devDesc.numberOfLines = 0
        presenter.devDesc.textAlignment = .justified
    }
    
    func setStack() {
        presenter.stack.addArrangedSubview(presenter.devName)
        presenter.stack.addArrangedSubview(presenter.devDesc)
        
        presenter.stack.spacing = 30
        presenter.stack.axis = .vertical
        presenter.stack.alignment = .fill
    }
    
    func setScrollViewConstraints() {
        presenter.scrollView.translatesAutoresizingMaskIntoConstraints = false
        presenter.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        presenter.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        presenter.scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        presenter.scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    }
    
    func setContentViewConstraints() {
        presenter.contentView.translatesAutoresizingMaskIntoConstraints = false
        presenter.contentView.topAnchor.constraint(equalTo: presenter.scrollView.topAnchor).isActive = true
        presenter.contentView.bottomAnchor.constraint(equalTo: presenter.scrollView.bottomAnchor).isActive = true
        presenter.contentView.trailingAnchor.constraint(equalTo: presenter.scrollView.trailingAnchor).isActive = true
        presenter.contentView.leadingAnchor.constraint(equalTo: presenter.scrollView.leadingAnchor).isActive = true
        presenter.contentView.widthAnchor.constraint(equalTo: presenter.scrollView.widthAnchor).isActive = true
    }
    
    func setDevImageConstraints() {
        presenter.devImage.translatesAutoresizingMaskIntoConstraints = false
        presenter.devImage.centerXAnchor.constraint(equalTo: presenter.contentView.centerXAnchor).isActive = true
        presenter.devImage.topAnchor.constraint(equalTo: presenter.contentView.topAnchor, constant: 12).isActive = true
        presenter.devImage.widthAnchor.constraint(equalToConstant: Constants.detailImageWidth).isActive = true
        presenter.devImage.heightAnchor.constraint(equalToConstant: Constants.detailImageHeight).isActive = true
    }
    
    func setStackConstraints() {
        presenter.stack.translatesAutoresizingMaskIntoConstraints = false
        presenter.stack.topAnchor.constraint(equalTo: presenter.devImage.bottomAnchor, constant: 20).isActive = true
        presenter.stack.centerXAnchor.constraint(equalTo: presenter.contentView.centerXAnchor).isActive = true
        presenter.stack.widthAnchor.constraint(equalTo: presenter.contentView.widthAnchor, multiplier: 0.9).isActive = true
        presenter.stack.bottomAnchor.constraint(equalTo: presenter.contentView.bottomAnchor).isActive = true
    }
}

