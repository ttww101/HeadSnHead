//
//  Activity.swift
//  ShopSide
//
//  Created by Wu on 2019/8/5.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit

enum ActivityType: String, CaseIterable {
    
    case create = "Create"
    case update = "Update"
    case delete = "Delete"
    
    static let allRawValues = [create.rawValue, update.rawValue, delete.rawValue]
}

class Activity {
    var type: ActivityType
    
    var owner: String
    var didDownloadFinishedOwnerImage: ((UIImage?)->())?
    
    private var _ownerImage: UIImage?
    var ownerImage: UIImage? {
        set {
            _ownerImage = newValue
        }
        get {
            if _ownerImage == nil {
                FirebaseManager.shared.getImage(from: self.ownerPhotoURL, completion: { (image, error) in
                    if let closure = self.didDownloadFinishedOwnerImage {
                        closure(image)
                    }
                    self._ownerImage = image
                })
            }
            return _ownerImage
        }
    }
    
    var ownerPhotoURL: String
    var activityID: String
    var title: String
    var content: String
    var productID: String
    var didDownloadFinishedProductImage: ((UIImage?)->())?
    private var _productImage: UIImage?
    var productImage: UIImage? {
        set {
            _productImage = newValue
        }
        get {
            if _productImage == nil {
                FirebaseManager.shared.getImage(from: self.productPhotoURL, completion: { (image, error) in
                    if let closure = self.didDownloadFinishedProductImage {
                        closure(image)
                    }
                    self._productImage = image
                })
            }
            return _productImage
        }
    }
    var productPhotoURL: String
    var time: String
    
    init(type: ActivityType, owner: String, ownerPhotoURL: String, activityID: String, title: String,  content: String, productID: String, productPhotoURL: String, time: String) {
        self.type = type
        self.owner = owner
        self.ownerPhotoURL = ownerPhotoURL
        self.activityID = activityID
        self.title = title
        self.content = content
        self.productID = productID
        self.productPhotoURL = productPhotoURL
        self.time = time
    }
    
    func switchToFirebaseJsonValue() -> [String: Any] {
        return [
            Config.Firebase.Activity.Keys.type : self.type.rawValue,
            Config.Firebase.Activity.Keys.owner : self.owner,
            Config.Firebase.Activity.Keys.ownerPhotoURL : self.ownerPhotoURL,
            Config.Firebase.Activity.Keys.activityID : self.activityID,
            Config.Firebase.Activity.Keys.title : self.title,
            Config.Firebase.Activity.Keys.content : self.content,
            Config.Firebase.Activity.Keys.productID : self.productID,
            Config.Firebase.Activity.Keys.productPhotoURL : self.productPhotoURL,
            Config.Firebase.Activity.Keys.time : self.time
        ]
    }
    
}
