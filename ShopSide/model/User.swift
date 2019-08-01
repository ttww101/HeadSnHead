//
//  User.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import Foundation

struct User {

    var email: String
    var name: String
    var gender: String
    var photoURL: String
    var userID: String

    init(userID: String, email: String, name: String, gender: String, photoURL: String) {

        self.userID = userID
        self.email = email
        self.name = name
        self.gender = gender
        self.photoURL = photoURL
    }
}
