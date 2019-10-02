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

class LandingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
