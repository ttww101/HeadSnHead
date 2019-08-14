//
//  ProfileViewController.swift
//  Courtman
//
//  Created by dina on 2019/07/05.
//  Copyright © 2019年 AGT. All rights reserved.
//

import UIKit
import Firebase
import YPImagePicker
import SkyFloatingLabelTextField

class ProfileViewController: BaseViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    var userImage: UIImage? = nil {
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

    let loadingIndicator = LoadingIndicator()
    var userOriginName = ""
    var isUpdated  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUserImageView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userImageView.layer.cornerRadius = userImageView.bounds.size.height / 2.0
    }

    // MARK: - Get User Info From Firebase
    func getUserInfo() {
        let user = CurrentUser.user
        self.nameTextField.text = user.name
        self.loadAndSetUserPhoto(user.photoURL)
    }

    // MARK: - Load User Picture From Firebase
    func loadAndSetUserPhoto(_ userPhotoUrlString: String) {

        DispatchQueue.global().async {

            let storageRef = Storage.storage().reference()
            
            let islandRef = storageRef.child(userPhotoUrlString)
            
            islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("=== \(error)")
                } else {
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        self.userImage = image
                        self.loadingIndicator.stop()
                    }
                }
            }
        }
    }

    func setUserImageView() {
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.masksToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Select Picture
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        presentImagePicker()
    }
    
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
        
        config.colors.tintColor = .cottonBlack() // Right bar buttons (actions)
        
        YPImagePickerConfiguration.shared = config
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            
            if let photo = items.singlePhoto {
                self.userImage = photo.image
                self.isUpdated = true

            } else {

            }

            picker.dismiss(animated: true, completion: nil)
            
        }
        present(picker, animated: true, completion: nil)
    }
    

    // MARK: - Save User Info to Firebase
    @IBAction func saveProfileInfo(_ sender: Any) {

        if (nameTextField.text != userOriginName) || isUpdated {

            self.loadingIndicator.start()

            guard let uid = Auth.auth().currentUser?.uid else { return }

            let storageRef = Storage.storage().reference()
                .child(Config.Firebase.Storage.userPhoto)
                .child(Config.Firebase.Storage.userPhoto + "_" + uid)

            // Delete the file
            storageRef.delete { error in

                if error == nil {

                    // File deleted successfully
                    self.uploadImageToFirebase(uid, storageRef)

                } else {
                    print("=== Error in EditProfileViewController01 \(String(describing: error))")
                }
            }

        } else {

            self.navigationController?.popViewController(animated: true)
        }
    }

    func uploadImageToFirebase(_ uid: String, _ storageRef: StorageReference) {

        guard
            let uploadData = self.userImageView.image!.jpegData(compressionQuality: 0.3)
            else { return }

        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in

            if error != nil {
                print("=== Firebase upload profile photo Error: \(String(describing: error))")
                return
            }

            let userPhotoURL = metadata?.path
            self.updateValueToFirebase(uid: uid,
                                       name: self.nameTextField.text!,
                                       userPhotoURL: userPhotoURL!)
        })
    }

    func updateValueToFirebase(uid: String, name: String, userPhotoURL: String) {

        let ref = Database.database().reference().child(Config.Firebase.User.nodeName).child(uid)

        let userUpdatedInfo = [Config.Firebase.User.name: name,
                               Config.Firebase.User.photoURL: userPhotoURL]

        ref.updateChildValues(userUpdatedInfo) { (error, _) in

            self.loadingIndicator.stop()

            if error == nil {
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Firebase update user name & photo url Error in EditProfileViewController: \(String(describing: error))")
            }
        }
    }

    @IBAction func cancelEdit(_ sender: Any) {

        self.navigationController?.popViewController(animated: true)
    }
}
