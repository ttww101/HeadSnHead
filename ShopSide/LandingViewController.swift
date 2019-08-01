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
        
        if Auth.auth().currentUser != nil {
            
            let storyboard = UIStoryboard(name: Config.Storyboard.product, bundle: nil)
            guard let productNav = storyboard.instantiateViewController(withIdentifier: Config.Controller.productNav) as? UINavigationController else { return }
            UIApplication.shared.delegate?.window??.rootViewController = productNav
        } else {
            
            let storyboard = UIStoryboard(name: Config.Storyboard.login, bundle: nil)
            guard let loginvc = storyboard.instantiateViewController(withIdentifier: Config.Controller.login) as? LoginViewController else { return }
            UIApplication.shared.delegate?.window??.rootViewController = loginvc
            
        }
        
    }

}
