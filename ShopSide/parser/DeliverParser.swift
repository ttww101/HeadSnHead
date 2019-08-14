//
//  DeliverParser.swift
//  ShopSide
//
//  Created by Wu on 2019/8/12.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import Firebase

class DeliverParser {
    
    func parserDeliver(_ snap: DataSnapshot) -> Deliver? {
        
        guard
            let dic = snap.value as? NSDictionary,
            let productID = dic[Config.Firebase.Delivers.Keys.productID] as? String,
            let state = dic[Config.Firebase.Delivers.Keys.state] as? String,
            let createTime = dic[Config.Firebase.Delivers.Keys.createTime] as? String,
            let address = dic[Config.Firebase.Delivers.Keys.address] as? String,
            let orderCount = dic[Config.Firebase.Delivers.Keys.orderCount] as? Int
            else { return nil }
        
        let deliver = Deliver(productID: productID, count: orderCount, address: address, createTime: createTime, state: DeliverState(rawValue: state) ?? .ordered)
        
        return deliver
    }
}

