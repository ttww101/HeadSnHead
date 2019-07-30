//
//  BaseViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/7/29.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public func createViewControllerFromStoryboard(name: String, identifier: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }

}
