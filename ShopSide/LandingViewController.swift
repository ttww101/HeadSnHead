//
//  LandingViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/7/24.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import GuillotineMenu

class LandingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Product", bundle: nil)
        guard let productNav = storyboard.instantiateViewController(withIdentifier: "ProductNavigationController") as? UINavigationController else { return }
        UIApplication.shared.delegate?.window??.rootViewController = productNav
    }

}
