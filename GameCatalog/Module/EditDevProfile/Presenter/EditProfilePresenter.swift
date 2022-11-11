//
//  EditProfilePresenter.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation
import UIKit

class EditProfilePresenter {
    
    weak var view: UIViewController?
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    var fieldName = UITextField()
    var fieldDesc = UITextView()
    
    var labelName = UILabel()
    var labelDesc = UILabel()
    
    var stackOne = UIStackView()
    var stackTWo = UIStackView()
    
    var buttonSave = UIButton()
    
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
        
        view?.present(alert, animated: true)
    }
}

