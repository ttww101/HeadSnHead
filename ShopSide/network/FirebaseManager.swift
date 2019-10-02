//
//  FirebaseManager.swift
//  ShopSide
//
//  Created by Wu on 2019/8/1.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import Firebase

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    let loadingIndicator = LoadingIndicator()
    
    typealias DataSnapshotHandler = (Result<DataSnapshot>) -> Void
    
    typealias DataSnapshotsHandler = (Result<[DataSnapshot]>) -> Void
    
    typealias UserHandler = (User?, Error?) -> Void
    
    typealias ImageHandler = (UIImage?, Error?) -> Void

}

//MARK: User Database
extension FirebaseManager {
    func getUserInfo(currentUserUID: String, completion: @escaping UserHandler) {
        
        var user: User?
        
        let ref = Database.database().reference()
            .child(Config.Firebase.User.nodeName)
            .child(currentUserUID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                guard
                    let userData = snapshot.value as? [String: Any]
                    else { return }
                
                guard
                    let userID = userData[Config.Firebase.User.userID] as? String,
                    let name = userData[Config.Firebase.User.name] as? String,
                    let email = userData[Config.Firebase.User.email] as? String,
                    let gender = userData[Config.Firebase.User.gender] as? String,
                    let photoURL = userData[Config.Firebase.User.photoURL] as? String
                    else { return }
                
                user = User(userID:userID, email: email, name: name, gender: gender,
                            photoURL: photoURL)
                
            } else {
                print("=== Firebase Can't find this user")
            }
            
            completion(user, nil)
            
        }) { (error) in
            
            completion(nil, error)
        }
    }
}

//MARK: Datebase
extension FirebaseManager {

    func getDataSnapshot(ref: DatabaseReference, completion: @escaping (DataSnapshotHandler)) {
        
        self.loadingIndicator.start()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.loadingIndicator.stop()
            
            if snapshot.exists() {
                
                completion(.success(snapshot))
                
            } else {
                
                completion(.error(NetworkError.emptyData))
            }
        })
    }
    
    func getDataSnapshots(ref: DatabaseReference, completion: @escaping (DataSnapshotsHandler)) {
        
        self.loadingIndicator.start()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.loadingIndicator.stop()
            
            ref.removeAllObservers()
            
            if snapshot.exists() {
                
                guard
                    let snaps = snapshot.children.allObjects as? [DataSnapshot]
                    else
                {
                    completion(.error(NetworkError.parseError))
                    return }
                
                completion(.success(snaps))
                
            } else {
                
                completion(.error(NetworkError.emptyData))
            }
        })
    }
    
    func createActivityData(value: [String: Any], completion: (()->())?) {
        
        let uuid = value[Config.Firebase.Activity.Keys.activityID] as! String
        
        self.updateAvtivityData(value: value, childID: uuid, completion: completion)
    }
    
    func updateAvtivityData(value: [String: Any], childID: String, completion: (()->())?) {
        
        let ref = Database.database().reference().child(Config.Firebase.Activity.nodeName)
        
        self.loadingIndicator.start()
        
        ref.child(childID).updateChildValues(value, withCompletionBlock: { (err, _) in
            
            self.loadingIndicator.stop()
            
            if err != nil {
                return
            } else {
                if let completion = completion {
                    completion()
                }
            }
        })
    }
    
    func updateData(value: [String: Any], ref: DatabaseReference, childID: String, completion: ((Error?)->())?) {
        
        self.loadingIndicator.start()
        
        ref.child(childID).updateChildValues(value, withCompletionBlock: { (err, _) in
            
            self.loadingIndicator.stop()
            
            if err != nil {
                if let completion = completion {
                    completion(err)
                }
                return
            } else {
                if let completion = completion {
                    completion(nil)
                }
            }
        })
    }
    
    func deleteData(ref: DatabaseReference, completion: (()->())?) {
        
        self.loadingIndicator.start()
        
        ref.removeValue { (error, ref) in
            
            self.loadingIndicator.stop()
            
            if let completion = completion {
                completion()
            }
        }
    }
    
}

//MARK: Image Storage
extension FirebaseManager {
    
    func getImage(from url: String, completion: @escaping ImageHandler) {
        
        let storageRef = Storage.storage().reference()
        
        let islandRef = storageRef.child(url)
        
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(nil, error)
            } else {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            }
        }
    }
}
