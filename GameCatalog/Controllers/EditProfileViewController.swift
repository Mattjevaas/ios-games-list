//
//  EditProfileViewController.swift
//  GameCatalog
//
//  Created by Admin on 30/09/22.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    
    var fieldName = UITextField()
    var fieldDesc = UITextView()
    
    var labelName = UILabel()
    var labelDesc = UILabel()
    
    var stackOne = UIStackView()
    var stackTWo = UIStackView()
    
    var buttonSave = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initilizeController()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackOne)
        contentView.addSubview(stackTWo)
        contentView.addSubview(buttonSave)
        
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
        
        initProfileData()
    }
}

// MARK: - Initial Setup
extension EditProfileViewController {
    func initilizeController() {
        view.backgroundColor = .white
        self.navigationItem.title = "Edit Profile"
    }
    
    func configureFieldName() {
        fieldName.placeholder = "Enter your name here"
        
        fieldName.borderStyle = .roundedRect
        fieldName.clipsToBounds = true
        fieldName.layer.borderColor = UIColor.lightGray.cgColor
        fieldName.layer.borderWidth = 1
        fieldName.layer.cornerRadius = 2
        fieldName.font = UIFont.systemFont(ofSize: 15)
    }
    
    func configureFieldDesc() {
        if fieldDesc.text == "" {
            fieldDesc.text = "Enter your self description here"
        }
        
        fieldDesc.clipsToBounds = true
        fieldDesc.layer.borderColor = UIColor.lightGray.cgColor
        fieldDesc.layer.borderWidth = 1
        fieldDesc.layer.cornerRadius = 2
        fieldDesc.font = UIFont.systemFont(ofSize: 15)
    }
    
    func configureLabel() {
        labelName.text = "Name"
        labelName.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        labelDesc.text = "Self Description"
        labelDesc.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    }
    
    func configureButtonSave() {
        buttonSave.backgroundColor = .systemBlue
        buttonSave.clipsToBounds = true
        buttonSave.layer.cornerRadius = 5
        buttonSave.setTitle("Save", for: .normal)
        buttonSave.addTarget(self, action: #selector(saveData), for: .touchUpInside)
    }
    
    func setStackOne() {
        stackOne.addArrangedSubview(labelName)
        stackOne.addArrangedSubview(fieldName)
        
        stackOne.spacing = 8
        stackOne.axis = .vertical
    }
    
    func setStackTwo() {
        stackTWo.addArrangedSubview(labelDesc)
        stackTWo.addArrangedSubview(fieldDesc)
        
        stackTWo.spacing = 8
        stackTWo.axis = .vertical
    }
    
    func setScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
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
    
    func setStackOneConstraints() {
        stackOne.translatesAutoresizingMaskIntoConstraints = false
        stackOne.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        stackOne.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        fieldName.translatesAutoresizingMaskIntoConstraints = false
        fieldName.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    func setStackTwoConstraints() {
        stackTWo.translatesAutoresizingMaskIntoConstraints = false
        stackTWo.topAnchor.constraint(equalTo: stackOne.bottomAnchor, constant: 20).isActive = true
        stackTWo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        fieldDesc.translatesAutoresizingMaskIntoConstraints = false
        fieldDesc.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        fieldDesc.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setButtonConstraints() {
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        buttonSave.topAnchor.constraint(equalTo: stackTWo.bottomAnchor, constant: 20).isActive = true
        buttonSave.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        buttonSave.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        buttonSave.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1).isActive = true
        buttonSave.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor).isActive = true
    }
    
}

// MARK: - Additional Functions
extension EditProfileViewController {
    func initProfileData() {
        let nameData = UserDefaults.standard.string(forKey: Constants.nameKey)
        let descData = UserDefaults.standard.string(forKey: Constants.descKey)
        
        if nameData != nil, descData != nil {
            fieldName.text = nameData
            fieldDesc.text = descData
        } else {
            fieldName.text = "Johanes Wiku Sakti"
            fieldDesc.text = "Passionate in Computer Science with a focus on web and mobile application development. Interested in learning new things especially about programming, entrepreneurship, and technology. A person who love to make new connection with others to share experiences with each other."
            
            UserDefaults.standard.set("Johanes Wiku Sakti", forKey: Constants.nameKey)
            UserDefaults.standard.set("Passionate in Computer Science with a focus on web and mobile application development. Interested in learning new things especially about programming, entrepreneurship, and technology. A person who love to make new connection with others to share experiences with each other.", forKey: Constants.descKey)
        }
    }
    
    @objc func saveData() {
        UserDefaults.standard.set(fieldName.text, forKey: Constants.nameKey)
        UserDefaults.standard.set(fieldDesc.text, forKey: Constants.descKey)
        
        showAlert(msg: "Success edit profile")
    }
    
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
