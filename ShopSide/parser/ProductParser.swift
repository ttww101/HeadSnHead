//
//  ProductParser.swift
//  ShopSide
//
//  Created by Wu on 2019/8/1.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import Firebase

class ProductParser {
    
    func parserProduct(_ snap: DataSnapshot) -> Product? {
        
        guard
            let dic = snap.value as? NSDictionary,
            let productID = dic[Config.Firebase.Product.Keys.productID] as? String,
            let name = dic[Config.Firebase.Product.Keys.name] as? String,
            let surname = dic[Config.Firebase.Product.Keys.surname] as? String,
            let color = dic[Config.Firebase.Product.Keys.color] as? String,
            let description = dic[Config.Firebase.Product.Keys.description] as? String,
            let owner = dic[Config.Firebase.Product.Keys.owner] as? String,
            let photoURL = dic[Config.Firebase.Product.Keys.photoURL] as? String,
            let availableCount = dic[Config.Firebase.Product.Keys.availableCount] as? Int,
            let price = dic[Config.Firebase.Product.Keys.price] as? String
        else { return nil }
        
        let product = Product(id: productID, name: name, surname: surname, avatar: UIImage(), photoURL: photoURL, availableCount: availableCount, color: color, description: description, owner: owner, price: price)
        
        FirebaseManager.shared.getImage(from: photoURL) { (image, error) in
            DispatchQueue.main.async {
                product.avatar = image
            }
        }
        
        return product
    }
}

