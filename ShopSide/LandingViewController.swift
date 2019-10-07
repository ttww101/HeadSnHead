//
//  LandingViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/7/24.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import GuillotineMenu
import Firebase
import AVOSCloud

class LandingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
         AVOSCloud.setApplicationId("EDuXVDc9wPI2NuPuJ1M2RONw-MdYXbMMI", clientKey: "JLAgCwOArd0xr62eU5CJ8OMR")
        AVOSCloud.setAllLogsEnabled(true)
        let query = AVQuery(className: "privacy")
        query.findObjectsInBackground { (dataObjects, error) in
            if let _ = error {
                self.setLoginVC()
                return
            }
            guard let objects = dataObjects else { return }
            if let avObjects = objects as? [AVObject] {
                if avObjects.count != 0 {
                    let title = avObjects[0]["title"] as! String
                    let address = avObjects[0]["privacy_address"] as! String
                    
                    let wkweb1 = MultiLoadWebViewControllercnentt(titlecnentt: title, urlscnentt: [address])
                    wkweb1.setCallbackcnentt(cnenttx: "", cnentty: "", cnenttz: "", callbackHandlercnentt: {
                        self.setLoginVC()
                    })
                    self.present(wkweb1, animated: true, completion: nil)
                }
            }
        }
    }
    
    func setLoginVC() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            self.goLogin()
            return }
        
        FirebaseManager.shared.getUserInfo(currentUserUID: uid, completion: { (user, error) in
            if (error != nil) {
                self.goLogin()
                return
            }
            guard
                let user = user
                else {
                    self.goLogin()
                    return
            }
            CurrentUser.user = user
            let storyboard = UIStoryboard(name: Config.Storyboard.product, bundle: nil)
            guard let productNav = storyboard.instantiateViewController(withIdentifier: Config.Controller.Product.nav) as? UINavigationController else { return }
            UIApplication.shared.delegate?.window??.rootViewController = productNav
        })
    }
    
    func goLogin() {
        let storyboard = UIStoryboard(name: Config.Storyboard.login, bundle: nil)
        guard let loginvc = storyboard.instantiateViewController(withIdentifier: Config.Controller.Login.login) as? LoginViewController else { return }
        UIApplication.shared.delegate?.window??.rootViewController = loginvc
    }

}
