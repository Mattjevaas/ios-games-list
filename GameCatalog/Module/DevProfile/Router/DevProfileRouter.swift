//
//  DevProfileRouter.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation

class DevProfileRouter {
    
    func makeEditProfileView() -> EditProfileView {
        let editProfilePresenter = EditProfilePresenter()
        return EditProfileView(presenter: editProfilePresenter)
    }
}
