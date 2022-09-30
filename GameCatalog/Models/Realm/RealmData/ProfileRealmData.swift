//
//  ProfileRealmData.swift
//  GameCatalog
//
//  Created by Admin on 29/09/22.
//

import RealmSwift

class ProfileRealmData: Object {
    @Persisted var userImage: Data
    @Persisted var userName: String
    @Persisted var userDesc: String
}
