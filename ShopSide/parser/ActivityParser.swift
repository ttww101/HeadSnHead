//
//  ActivityParser.swift
//  ShopSide
//
//  Created by Wu on 2019/8/5.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import Firebase

class ActivityParser {
    
    func parserActivity(_ snap: DataSnapshot) -> Activity? {
        
        guard
            let dic = snap.value as? NSDictionary,
            let type = dic[Config.Firebase.Activity.Keys.type] as? String,
            let owner = dic[Config.Firebase.Activity.Keys.owner] as? String,
            let ownerPhotoURL = dic[Config.Firebase.Activity.Keys.ownerPhotoURL] as? String,
            let activityID = dic[Config.Firebase.Activity.Keys.activityID] as? String,
            let title = dic[Config.Firebase.Activity.Keys.title] as? String,
            let content = dic[Config.Firebase.Activity.Keys.content] as? String,
            let productID = dic[Config.Firebase.Activity.Keys.productID] as? String,
            let productPhotoURL = dic[Config.Firebase.Activity.Keys.productPhotoURL] as? String,
            let time = dic[Config.Firebase.Activity.Keys.time] as? String
            else { return nil }
        
        let activity = Activity(type: ActivityType(rawValue: type) ?? ActivityType.update, owner: owner, ownerPhotoURL: ownerPhotoURL, activityID: activityID, title: title, content: content, productID: productID, productPhotoURL: productPhotoURL, time: time)
        
        return activity
    }
}

