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

    func showErrorAlert(error: Error?, myErrorMsg: String?, completion: (()->())? = nil) {
        
        var errorMsg: String = ""
        
        if error != nil {
            errorMsg = (error?.localizedDescription)!
        } else if myErrorMsg != nil {
            errorMsg = myErrorMsg!
        }
        
        let alertController = UIAlertController(title: "提示訊息", message: errorMsg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "確認", style: .cancel, handler: { (alert) in
            if let completion = completion {
                completion()
            }
        })
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
