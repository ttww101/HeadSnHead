//
//  MenuViewController.swift
//  GuillotineMenuExample
//
//  Created by Maksym Lazebnyi on 10/8/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit
import GuillotineMenu
import StoreKit

class MenuViewController: UIViewController, GuillotineMenu {
    
    @IBOutlet var menuFirstButton: UIButton!
    @IBOutlet var menuSecondButton: UIButton!
    @IBOutlet var menuThirdButton: UIButton!
    @IBOutlet var menuFourthButton: UIButton!
    @IBOutlet var menuFifthButton: UIButton!
    
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    open var tappedLogOutClosure: (() -> ())? = nil
    open var tappedProductClosure: (() -> ())? = nil
    open var tappedActivityClosure: (() -> ())? = nil
    open var tappedDeliverClosure: (() -> ())? = nil
    open var tappedSettingClosure: (() -> ())? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton = {
            let button = UIButton(frame: .zero)
            button.tintColor = .black
            button.setImage(UIImage(named: "ic_menu"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = "Activity"
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()
        
        self.setupMenuButton()
    }
    
    func setupMenuButton() {
        self.menuFirstButton.setTitle(Config.Menu.names[0], for: .normal)
        self.menuSecondButton.setTitle(Config.Menu.names[1], for: .normal)
        self.menuThirdButton.setTitle(Config.Menu.names[2], for: .normal)
        self.menuFourthButton.setTitle(Config.Menu.names[3], for: .normal)
        self.menuFifthButton.setTitle(Config.Menu.names[4], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            if let closure = tappedProductClosure {
                closure()
            }
        } else if sender.tag == 1 {
            if let closure = tappedActivityClosure {
                closure()
            }
        } else if sender.tag == 2 {
            if let closure = tappedDeliverClosure {
                closure()
            }
        } else if sender.tag == 3 {
            if let closure = tappedSettingClosure {
                closure()
            }
        } else if sender.tag == 4 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
            return
        }
        
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeMenu(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
        if let closure = tappedLogOutClosure {
            closure()
        }
    }
}

extension MenuViewController: GuillotineAnimationDelegate {
    
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
    }
}
