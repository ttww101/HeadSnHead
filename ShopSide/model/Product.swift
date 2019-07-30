//
//  Product.swift
//  ShopSide
//
//  Created by Wu on 2019/7/25.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit

class Product {
    
    var name: String
    var surname: String
    var avatar: UIImage?
    var availableCount: Int
    var color: String
    var description: String
    
    init(name: String, surname: String, avatar: UIImage?, availableCount: Int, color: String, description: String = "") {
        self.name = name
        self.surname = surname
        self.avatar = avatar
        self.availableCount = availableCount
        self.color = color
        self.description = description
    }
    
}
