//
//  ProductEditViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/7/29.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import YPImagePicker
import Firebase

enum ProductEditType {
    case edit
    case add
}

class ProductEditViewController: BaseViewController {

    var didUpdateClosure: ((Product?)->())? = nil
    let loadingIndicator = LoadingIndicator()
    @IBOutlet weak var tableView: UITableView!
    var product: Product? = nil
    var type: ProductEditType = .edit {
        didSet {
            switch self.type {
            case .edit:
                self.title = "Edit"
                self.okButtonTitleText = "Update"
                
            case .add:
                self.title = "Add"
                self.okButtonTitleText = "Add"
            }
        }
    }
    let activityChangedContent = ActivityChangedContent()
    var okButtonTitleText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapEndEditingMethod(to: self.tableView)
        self.tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: Config.TableViewCell.Product.edit, bundle: nil), forCellReuseIdentifier: Config.TableViewCell.Product.edit)
    }
}

// MARK: - Table view data source
extension ProductEditViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Config.TableViewCell.Product.edit, for: indexPath) as! ProductEditTableViewCell
            cell.didTapAvatarImageClosure = {
                self.presentImagePicker()
            }
            cell.activityChangedContent = self.activityChangedContent
            cell.didTapOkButtonClosure = {
                self.saveProduct(completion: {
                    self.navigationController?.popViewController(animated: true)
                    if let closure = self.didUpdateClosure {
                        closure(self.product)
                    }
                    
                    var activityType: ActivityType = .create
                    var content = ""
                    switch self.type {
                    case .add:
                        activityType = .create
                        content = "new product"
                    case .edit:
                        activityType = .update
                        content = self.activityChangedContent.createString()
                    }
                    let title = "\(activityType)"
                    
                    let owner = CurrentUser.user.name
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd HH:mm"
                    formatter.locale = Locale.current
                    let currentTime = formatter.string(from: Date())
                        
                    let activity = Activity(type: activityType, owner: owner, ownerPhotoURL:  CurrentUser.user.photoURL,  activityID: UUID().uuidString, title: title, content: content, productID: self.product?.id ?? "no product id", productPhotoURL: self.product?.photoURL ?? "", time: currentTime)
                    
                    switch self.type {
                    case .edit:
                        FirebaseManager.shared
                            .createActivityData(
                                value: activity.switchToFirebaseJsonValue(), completion: nil)
                        
                    case .add:
                        FirebaseManager.shared
                            .createActivityData(value: activity.switchToFirebaseJsonValue(), completion: nil)
                    }
                })
            }
            cell.textViewDidChangedClosure = { (textView) in
                let startHeight = textView.frame.size.height
                let calcHeight = textView.sizeThatFits(textView.frame.size).height
                if (startHeight != calcHeight) {
                    UIView.setAnimationsEnabled(false)
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                    UIView.setAnimationsEnabled(true)
                }
            }
            cell.didUpdateProductClosure = { (product) in
                self.product = product
            }
            if let product = product {
                cell.product = product
            } else {
                cell.product = Product(name: "", surname: "", avatar: nil, photoURL: "", availableCount: 0, color: "", price: "0")
            }
            cell.okButton.titleString = self.okButtonTitleText
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

//MARK: Private
extension ProductEditViewController {
    
    func saveProduct(completion: (()->())?) {
        
        //product info
        let ref = Database.database().reference().child(Config.Firebase.Product.nodeName)
        
        var value: [String: Any] = [:]
        let id: String = self.product?.id ?? UUID().uuidString
        if let product = self.product {
            value.updateValue(id, forKey: Config.Firebase.Product.Keys.productID)
            value.updateValue(product.name, forKey: Config.Firebase.Product.Keys.name)
            value.updateValue(product.surname, forKey: Config.Firebase.Product.Keys.surname)
            value.updateValue(Auth.auth().currentUser?.uid ?? "Unknown User (May Not Login)", forKey: Config.Firebase.Product.Keys.owner)
            value.updateValue(product.color, forKey: Config.Firebase.Product.Keys.color)
            value.updateValue(product.description, forKey: Config.Firebase.Product.Keys.description)
            value.updateValue(product.availableCount, forKey: Config.Firebase.Product.Keys.availableCount)
            value.updateValue(product.price, forKey: Config.Firebase.Product.Keys.price)
            value.updateValue(Config.Firebase.Storage.productPhoto + "/" + Config.Firebase.Storage.productPhoto + "_" + id, forKey: Config.Firebase.Product.Keys.photoURL)
            value.updateValue(Config.Firebase.Storage.productPhoto + "/" + Config.Firebase.Storage.productPhoto + "_" + id, forKey: Config.Firebase.Product.Keys.photoURL)
        } else {
            self.showErrorAlert(error: nil, myErrorMsg: "此商品更新失敗") {
                if let completion = completion {
                    completion()
                }
            }
            return
        }
        
        self.loadingIndicator.start()
        
        ref.child(id).updateChildValues(value, withCompletionBlock: { (err, _) in
            
            self.loadingIndicator.stop()
            
            if err != nil {
                self.showErrorAlert(error: err, myErrorMsg: nil)
                return
            } else {
                if let completion = completion {
                    completion()
                }
            }
            
        })
        
        //product photo
        let storageRef = Storage.storage().reference()
            .child(Config.Firebase.Storage.productPhoto)
            .child(Config.Firebase.Storage.productPhoto + "_" + id)
        
        guard
            let uploadData = self.product?.avatar?.jpegData(compressionQuality: 0.3)
            else { return }
        
        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                
                self.showErrorAlert(error: error, myErrorMsg: nil)
                return
            }
            
//            let userPhotoURL = metadata?.path
        })

    }
    
    func presentImagePicker() {
        var config = YPImagePickerConfiguration()
        config.wordings.libraryTitle = "Gallery"
        config.wordings.cameraTitle = "Camera"
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = true
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        config.albumName = Config.AppAssociateName
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.photo,.library]
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.bottomMenuItemSelectedColour = .lightRoss()
        config.bottomMenuItemUnSelectedColour = .cottonBlack()
        config.showsCrop = .rectangle(ratio: 3/2)
        
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
                self.product?.avatar = photo.image
                self.activityChangedContent.isPhoto = true
                self.tableView.reloadData()
            }
            
            picker.dismiss(animated: true, completion: nil)
            
        }
        
//        //navigation bar
//        let attributes = [
//            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22, weight: .medium),
//            NSAttributedString.Key.foregroundColor: UIColor.white
//        ]
//        UINavigationBar.appearance().titleTextAttributes = attributes // Title fonts
//
//        picker.navigationBar.tintColor = .white // Left. bar buttons
//
        //bar background
//        let coloredImage = UIColor.hexColor(with: "454545").image()
//        picker.navigationBar.setBackgroundImage(coloredImage, for: UIBarMetrics.default)
        
//        picker.tabBarController?.tabBar.backgroundColor = UIColor.hexColor(with: "454545")
        
        present(picker, animated: true, completion: nil)
    }
}
