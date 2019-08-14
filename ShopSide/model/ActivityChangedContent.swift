//
//  ActivityChangedContent.swift
//  ShopSide
//
//  Created by Wu on 2019/8/6.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import Foundation

class ActivityChangedContent {
    var isName = false
    var isCount = false
    var isColor = false
    var isPrice = false
    var isPhoto = false
    var isDescription = false
    
    var product: Product?
    
    func createString() -> String {
        guard let product = product else { return "" }
        var str = ""
        str.append(isName ? "name: \(product.name)\n" : "")
        str.append(isCount ? "count: \(product.availableCount) \n" : "")
        str.append(isColor ? "color: \(product.color)\n" : "")
        str.append(isPrice ? "price: \(product.price)\n" : "")
        str.append(isPhoto ? "photo\n" : "")
        str.append(isDescription ? "description: \(product.description)" : "")
        return str
    }
}
