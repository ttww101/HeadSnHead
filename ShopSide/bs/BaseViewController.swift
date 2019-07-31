//
//  BaseViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/7/29.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var isEnableTapEndEditing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public func createViewControllerFromStoryboard(name: String, identifier: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    func addTapEndEditingMethod(to subview: UIView) {
        let isContain = self.view.subviews.contains(subview)
        if !isContain { return }
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(didTappedView))
        subview.addGestureRecognizer(tapGes)
    }
    
    @objc func didTappedView() {
        self.view.endEditing(true)
    }

}
