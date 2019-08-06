//
//  LoginViewController.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import SkyFloatingLabelTextField
import LGButton

class LoginViewController: BaseViewController {

    @IBOutlet weak var emailTexfield: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var logoImageView: UIImageView!

    let loadingIndicator = LoadingIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addTapEndEditingMethod(to: self.view)

        setView()
        self.logoImageView.layer.masksToBounds = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        loadingIndicator.stop()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.logoImageView.layer.cornerRadius = self.logoImageView.frame.width/4
    }

    // todo: confirm use it or not.
//    func isUsersignedin() {
//
//        Auth.auth().addStateDidChangeListener { _, user in
//            if user != nil {
//                // User is signed in.
//                print("=== User is signed in ===")
//                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//
//                    let vc = self.createViewControllerFromStoryboard(name: Config.Storyboard.product, identifier: Config.Controller.productNav)
//
//                    appDelegate.window?.rootViewController = vc
//                }
//            } else {
//                // No user is signed in.
//                print("=== No user sign in ===")
//            }
//        }
//    }

    func setView() {
//        setBackground(imageName: Config.BackgroundName.login)
    }

    @IBAction func login(_ sender: LGButton) {
        
        let email = emailTexfield.text!
        let password = passwordTextfield.text!

        // MARK: Loading indicator
        loadingIndicator.start()
        sender.isLoading = true

        Auth.auth().signIn(withEmail: email, password: password, completion: { (_, error) in

            sender.isLoading = false
            self.loadingIndicator.stop()
            
            if error != nil {
                self.showErrorAlert(error: error, myErrorMsg: nil)
                return
            }

            // successfully login
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

                let vc = self.createViewControllerFromStoryboard(name: Config.Storyboard.product, identifier: Config.Controller.Product.nav)
                
                appDelegate.window?.rootViewController = vc
                
            }
        })
    }

    @IBAction func signUp(_ sender: Any) {
        let sb = UIStoryboard(name: Config.Storyboard.login, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: Config.Controller.Login.register) as? RegisterViewController else { return }
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func forgetPassword(_ sender: Any) {

        if emailTexfield.text == "" {

            self.showAlert(myMsg: "請先填寫您所註冊的Email 在 Email 欄位\n填完後點選 Forget?\n我們將會寄送一封重設密碼對郵件給您")

        } else {

            let ref = Auth.auth()

            ref.sendPasswordReset(withEmail: emailTexfield.text!, completion: { (error) in

                if error != nil {
                    self.showAlert(myMsg: "此 Email 尚未註冊\n請確認您所填寫之 Email 是否正確")
                } else {
                    self.showAlert(myMsg: "我們已寄送一封重設密碼郵件給您")
                }
            })
        }
    }

    func showAlert(myMsg: String?) {

        let alertController = UIAlertController(title: "通知",
                                                message: myMsg,
                                                preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
