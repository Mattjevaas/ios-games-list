//
//  DevProfilePresenter.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation
import UIKit

class DevProfilePresenter {
    
    private let router = DevProfileRouter()
    weak var view: UIViewController?
    
    var devImage = UIImageView()
    var devName = UILabel()
    var devDesc = UILabel()
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    var stack = UIStackView()
    
    @objc func goToEditProfile() {
        
        let editProfileView = router.makeEditProfileView()
        view?.navigationController?.pushViewController(editProfileView, animated: true)
    }
    
    func initProfileData() {
        let nameData = UserDefaults.standard.string(forKey: Constants.nameKey)
        let descData = UserDefaults.standard.string(forKey: Constants.descKey)
        
        if nameData != nil, descData != nil {
            devName.text = nameData
            devDesc.text = descData
        } else {
            devName.text = "Johanes Wiku Sakti"
            devDesc.text = "Passionate in Computer Science with a focus on web and mobile application development. Interested in learning new things especially about programming, entrepreneurship, and technology. A person who love to make new connection with others to share experiences with each other."
            
            UserDefaults.standard.set("Johanes Wiku Sakti", forKey: Constants.nameKey)
            UserDefaults.standard.set("Passionate in Computer Science with a focus on web and mobile application development. Interested in learning new things especially about programming, entrepreneurship, and technology. A person who love to make new connection with others to share experiences with each other.", forKey: Constants.descKey)
        }
    }
    
    func makeEditProfileView() -> EditProfileView {
        return router.makeEditProfileView()
    }
}
