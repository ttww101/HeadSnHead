//
//  Deliver.swift
//  ShopSide
//
//  Created by Wu on 2019/8/10.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import Foundation

enum DeliverState: String {
    case ordered = "Ordered"
    case delivering = "Delivering"
    case delivered = "Delivered"
}

class Deliver {
    
    var state: DeliverState
    
    var productID: String
    var orderCount: Int
    var address: String
    
    init(productID: String, count: Int, address: String, state: DeliverState = .ordered) {
        self.productID = productID
        self.orderCount = count
        self.address = address
        self.state = state
    }
    
    func createValue() -> Dictionary<String, Any> {
        
        var value: [String: Any] = [:]
        
        value.updateValue(self.state.rawValue, forKey: Config.Firebase.Delivers.Keys.state)
        value.updateValue(self.productID, forKey: Config.Firebase.Delivers.Keys.productID)
        value.updateValue(self.address, forKey: Config.Firebase.Delivers.Keys.address)
        value.updateValue(self.orderCount, forKey: Config.Firebase.Delivers.Keys.orderCount)
        return value
    }
}
