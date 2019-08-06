//
//  Product.swift
//  ShopSide
//
//  Created by Wu on 2019/7/25.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import Firebase

class Product {
    
    var productDidChangedImage: ((UIImage?)->())? = nil
    
    var id: String?
    var name: String
    var surname: String
    var avatar: UIImage? {
        didSet {
            if let closure = self.productDidChangedImage {
                closure(self.avatar)
            }
        }
    }
    var availableCount: Int
    var color: String
    var description: String
    var owner: String
    var price: String
    var photoURL: String
    
    init(id: String? = nil, name: String, surname: String, avatar: UIImage?, photoURL: String , availableCount: Int, color: String, description: String = "", owner: String = "", price: String) {
        self.id = id
        self.name = name
        self.surname = surname
        self.avatar = avatar
        self.photoURL = photoURL
        self.availableCount = availableCount
        self.color = color
        self.description = description
        self.owner = owner
        self.price = price
    }
    
    
}
