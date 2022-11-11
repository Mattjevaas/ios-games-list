//
//  EditProfileView.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import UIKit

class EditProfileView: UIViewController {
    
    var presenter: EditProfilePresenter
    
    init(presenter: EditProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Missing edit profile presenter.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initilizeController()
        
        view.addSubview(presenter.scrollView)
        presenter.scrollView.addSubview(presenter.contentView)
        presenter.contentView.addSubview(presenter.stackOne)
        presenter.contentView.addSubview(presenter.stackTWo)
        presenter.contentView.addSubview(presenter.buttonSave)
        
        configureFieldName()
        configureFieldDesc()
        configureLabel()
        configureButtonSave()
        
        setStackOne()
        setStackTwo()
        
        setScrollViewConstraints()
        setContentViewConstraints()
        setStackOneConstraints()
        setStackTwoConstraints()
        setButtonConstraints()
        
        presenter.initProfileData()
    }
}

// MARK: - Initial Setup
extension EditProfileView {
    func initilizeController() {
        view.backgroundColor = .white
        self.navigationItem.title = "Edit Profile"
        
        presenter.view = self
    }
    
    func configureFieldName() {
        presenter.fieldName.placeholder = "Enter your name here"
        
        presenter.fieldName.borderStyle = .roundedRect
        presenter.fieldName.clipsToBounds = true
        presenter.fieldName.layer.borderColor = UIColor.lightGray.cgColor
        presenter.fieldName.layer.borderWidth = 1
        presenter.fieldName.layer.cornerRadius = 2
        presenter.fieldName.font = UIFont.systemFont(ofSize: 15)
    }
    
    func configureFieldDesc() {
        if presenter.fieldDesc.text == "" {
            presenter.fieldDesc.text = "Enter your self description here"
        }
        
        presenter.fieldDesc.clipsToBounds = true
        presenter.fieldDesc.layer.borderColor = UIColor.lightGray.cgColor
        presenter.fieldDesc.layer.borderWidth = 1
        presenter.fieldDesc.layer.cornerRadius = 2
        presenter.fieldDesc.font = UIFont.systemFont(ofSize: 15)
    }
    
    func configureLabel() {
        presenter.labelName.text = "Name"
        presenter.labelName.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        presenter.labelDesc.text = "Self Description"
        presenter.labelDesc.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    }
    
    func configureButtonSave() {
        presenter.buttonSave.backgroundColor = .systemBlue
        presenter.buttonSave.clipsToBounds = true
        presenter.buttonSave.layer.cornerRadius = 5
        presenter.buttonSave.setTitle("Save", for: .normal)
        presenter.buttonSave.addTarget(self, action: #selector(presenter.saveData), for: .touchUpInside)
    }
    
    func setStackOne() {
        presenter.stackOne.addArrangedSubview(presenter.labelName)
        presenter.stackOne.addArrangedSubview(presenter.fieldName)
        
        presenter.stackOne.spacing = 8
        presenter.stackOne.axis = .vertical
    }
    
    func setStackTwo() {
        presenter.stackTWo.addArrangedSubview(presenter.labelDesc)
        presenter.stackTWo.addArrangedSubview(presenter.fieldDesc)
        
        presenter.stackTWo.spacing = 8
        presenter.stackTWo.axis = .vertical
    }
    
    func setScrollViewConstraints() {
        presenter.scrollView.translatesAutoresizingMaskIntoConstraints = false
        presenter.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
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
    
    func setStackOneConstraints() {
        presenter.stackOne.translatesAutoresizingMaskIntoConstraints = false
        presenter.stackOne.topAnchor.constraint(equalTo: presenter.contentView.topAnchor, constant: 20).isActive = true
        presenter.stackOne.centerXAnchor.constraint(equalTo: presenter.contentView.centerXAnchor).isActive = true
        
        presenter.fieldName.translatesAutoresizingMaskIntoConstraints = false
        presenter.fieldName.widthAnchor.constraint(equalTo: presenter.contentView.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    func setStackTwoConstraints() {
        presenter.stackTWo.translatesAutoresizingMaskIntoConstraints = false
        presenter.stackTWo.topAnchor.constraint(equalTo: presenter.stackOne.bottomAnchor, constant: 20).isActive = true
        presenter.stackTWo.centerXAnchor.constraint(equalTo: presenter.contentView.centerXAnchor).isActive = true
        
        presenter.fieldDesc.translatesAutoresizingMaskIntoConstraints = false
        presenter.fieldDesc.widthAnchor.constraint(equalTo: presenter.contentView.widthAnchor, multiplier: 0.9).isActive = true
        presenter.fieldDesc.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setButtonConstraints() {
        presenter.buttonSave.translatesAutoresizingMaskIntoConstraints = false
        presenter.buttonSave.topAnchor.constraint(equalTo: presenter.stackTWo.bottomAnchor, constant: 20).isActive = true
        presenter.buttonSave.centerXAnchor.constraint(equalTo: presenter.contentView.centerXAnchor).isActive = true
        presenter.buttonSave.widthAnchor.constraint(equalTo: presenter.contentView.widthAnchor, multiplier: 0.9).isActive = true
        presenter.buttonSave.heightAnchor.constraint(equalTo: presenter.contentView.heightAnchor, multiplier: 0.1).isActive = true
        presenter.buttonSave.bottomAnchor.constraint(lessThanOrEqualTo: presenter.contentView.bottomAnchor).isActive = true
    }
    
}
