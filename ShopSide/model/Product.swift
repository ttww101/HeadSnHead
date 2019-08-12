//
//  self.swift
//  ShopSide
//
//  Created by Wu on 2019/7/25.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import Firebase

class Product {
    
    var productDidChangedImage: ((UIImage?)->())? = nil
    
    var id: String
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
    
    init(id: String, name: String, surname: String, avatar: UIImage?, photoURL: String , availableCount: Int, color: String, description: String = "", owner: String = "", price: String) {
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
    
    func createValue() -> Dictionary<String, Any> {
        
        var value: [String: Any] = [:]
        
        value.updateValue(self.id, forKey: Config.Firebase.Product.Keys.productID)
        value.updateValue(self.name, forKey: Config.Firebase.Product.Keys.name)
        value.updateValue(self.surname, forKey: Config.Firebase.Product.Keys.surname)
        value.updateValue(Auth.auth().currentUser?.uid ?? "Unknown User (May Not Login)", forKey: Config.Firebase.Product.Keys.owner)
        value.updateValue(self.color, forKey: Config.Firebase.Product.Keys.color)
        value.updateValue(self.description, forKey: Config.Firebase.Product.Keys.description)
        value.updateValue(self.availableCount, forKey: Config.Firebase.Product.Keys.availableCount)
        value.updateValue(self.price, forKey: Config.Firebase.Product.Keys.price)
        value.updateValue(self.photoURL, forKey: Config.Firebase.Product.Keys.photoURL)
        
        return value
    }
    
}
