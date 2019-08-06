//
//  RegisterViewController.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import YPImagePicker

class RegisterViewController: BaseViewController {

    @IBOutlet fileprivate weak var userImageView: ShadowImageView!
    var userImage: UIImage? {
        didSet {
            if self.userImage == nil {
                self.userImageView.image = UIImage(named: "ic_profile")
                self.userImageView.contentMode = .center
            } else {
                self.userImageView.image = self.userImage
                self.userImageView.contentMode = .scaleAspectFill
            }
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!

    let loadingIndicator = LoadingIndicator()

    private var userGender = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addTapEndEditingMethod(to: self.view)

        setView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        userImageView.layer.cornerRadius = userImageView.bounds.size.height / 2.0
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.masksToBounds = true
    }

    func setView() {

//        setBackground(imageName: Config.BackgroundName.login)

        emailTextField.clearButtonMode = .whileEditing
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.delegate = self

        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.autocorrectionType = .no
        passwordTextField.delegate = self
        
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.autocorrectionType = .no
        nameTextField.delegate = self

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Select Picture
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.presentImagePicker()
    }

    // MARK: - Sign up
    @IBAction func signUp(_ sender: Any) {

        userGender = "Default"

        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        let name = self.nameTextField.text!
        let gender = self.userGender

        if email != "" && password != "" && name != "" && userGender != "" {

            // MARK: Start loading indicator
            loadingIndicator.start()

            // MARK: Save user info to firebase
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in

                self.loadingIndicator.stop()
                
                if error != nil {
                    self.showErrorAlert(error: error, myErrorMsg: nil)
                    return
                }

                guard let currentUser = Auth.auth().currentUser else { return }

                //save photo
                let uid = currentUser.uid
            
                let storageRef = Storage.storage().reference()
                    .child(Config.Firebase.Storage.userPhoto)
                    .child(Config.Firebase.Storage.userPhoto + "_" + uid)

                guard
                    let uploadData = self.userImageView.image!.jpegData(compressionQuality: 0.3)
                    else { return }
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        
                        self.showErrorAlert(error: error, myErrorMsg: nil)
                        return
                    }

                    let userPhotoURL = metadata?.path

                    let userInfo = User(userID:uid, email: email, name: name, gender: gender,
                                    photoURL: userPhotoURL ?? "")
                    
                    self.setValueToFirebase(uid: uid, userInfo: userInfo)
                })
            }

        } else {
            self.loadingIndicator.stop()
            self.showErrorAlert(error: nil, myErrorMsg: "請確認您已填完所有欄位")
        }
    }

    func setValueToFirebase(uid: String, userInfo: User) {

        let dbUrl = Config.Firebase.dbUrl
        let ref = Database.database().reference(fromURL: dbUrl)
        let usersReference = ref.child(Config.Firebase.User.nodeName).child(uid)

        let value: [String : Any] = [
            Config.Firebase.User .userID: userInfo.userID,
            Config.Firebase.User.email: userInfo.email,
                     Config.Firebase.User.name: userInfo.name,
                     Config.Firebase.User.gender: userInfo.gender,
                     Config.Firebase.User.photoURL: userInfo.photoURL]

        self.loadingIndicator.start()
        
        usersReference.updateChildValues(value, withCompletionBlock: { (err, _) in

            self.loadingIndicator.stop()
            
            if err != nil {
                self.showErrorAlert(error: err, myErrorMsg: nil)
                return
            }
            
            // successfully
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                
                let vc = self.createViewControllerFromStoryboard(name: Config.Storyboard.main, identifier: Config.Controller.Main.landing)
                
                appDelegate.window?.rootViewController = vc
                
            }

        })
    }

    @IBAction func cancelButtonDidTouchUpInSide(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - Hide keyboard when user clicks the return on keyboard
extension RegisterViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.view.endEditing(true)
        return true
    }
}

extension RegisterViewController {
    
    func presentImagePicker() {
        var config = YPImagePickerConfiguration()
        config.wordings.libraryTitle = "Gallery"
        config.wordings.cameraTitle = "Camera"
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = true
        config.showsPhotoFilters = true
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "CourtsMan"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.photo,.library]
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.bottomMenuItemSelectedColour = UIColor.hexColor(with: "dd7663")
        config.bottomMenuItemUnSelectedColour = UIColor.hexColor(with: "454545")
        
        config.library.options = nil
        config.library.onlySquare = false
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        
        //navigation bar
        let attributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes // Title fonts
        
        UINavigationBar.appearance().tintColor = .white // Left. bar buttons
        config.colors.tintColor = .white // Right bar buttons (actions)
        
        //bar background
        let coloredImage = UIColor.hexColor(with: "454545").image()
        UINavigationBar.appearance().setBackgroundImage(coloredImage, for: UIBarMetrics.default)
        
        
        let barButtonAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .regular)]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: .normal) // Bar Button fonts
        
        UITabBar.appearance().backgroundColor = UIColor.hexColor(with: "454545")
        
        YPImagePickerConfiguration.shared = config
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            
            if let photo = items.singlePhoto {
                self.userImage = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
            
        }
        present(picker, animated: true, completion: nil)
    }
    
}
