//
//  BaseDropMenuViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/7/24.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import GuillotineMenu
import Firebase

class BaseDropMenuViewController: BaseViewController {

    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navBar = self.navigationController?.navigationBar
        navBar?.barTintColor = UIColor.white
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "ic_menu"), for: .normal)
        btn1.tintColor = .black
        btn1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn1.addTarget(self, action: #selector(menuDropDown), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        
        self.navigationItem.leftBarButtonItem  = item1
    }
    
    @objc func menuDropDown(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        guard let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self
        
        menuViewController.tappedActivityClosure = {
            let storyboard = UIStoryboard(name: Config.Storyboard.activity, bundle: nil)
            guard let nav = storyboard.instantiateViewController(withIdentifier: Config.Controller.Activity.nav) as? UINavigationController else { return }
            UIApplication.shared.delegate?.window??.rootViewController = nav
        }
        menuViewController.tappedProductClosure = {
            let storyboard = UIStoryboard(name: Config.Storyboard.product, bundle: nil)
            guard let nav = storyboard.instantiateViewController(withIdentifier: Config.Controller.Product.nav) as? UINavigationController else { return }
            
            UIApplication.shared.delegate?.window??.rootViewController = nav
        }
        menuViewController.tappedDeliverClosure = {
            let storyboard = UIStoryboard(name: Config.Storyboard.deliver, bundle: nil)
            guard let nav = storyboard.instantiateViewController(withIdentifier: Config.Controller.Deliver.nav) as? UINavigationController else { return }
            UIApplication.shared.delegate?.window??.rootViewController = nav
        }
        menuViewController.tappedSettingClosure = {
            let storyboard = UIStoryboard(name: Config.Storyboard.setting, bundle: nil)
            guard let nav = storyboard.instantiateViewController(withIdentifier: Config.Controller.Setting.nav) as? UINavigationController else { return }
            UIApplication.shared.delegate?.window??.rootViewController = nav
        }
        
        menuViewController.tappedLogOutClosure = {
            
            do {
                try Auth.auth().signOut()
            } catch let logoutError {
                self.showErrorAlert(error: logoutError, myErrorMsg: nil)
            }
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                
                let loginStorybard = UIStoryboard(name: Config.Storyboard.login, bundle: nil)
                let loginViewController = loginStorybard.instantiateViewController(withIdentifier: Config.Controller.Login.login) as? LoginViewController
                
                appDelegate.window?.rootViewController = loginViewController
            }
        }
        
        presentationAnimator.animationDelegate = menuViewController
        presentationAnimator.supportView = navigationController!.navigationBar
        presentationAnimator.presentButton = sender
        presentationAnimator.animationDuration = 0.15
        
        present(menuViewController, animated: true, completion: nil)
    }

}

extension BaseDropMenuViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}

