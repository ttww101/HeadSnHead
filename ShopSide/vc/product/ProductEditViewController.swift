//
//  ProductEditViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/7/29.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import YPImagePicker

enum ProductEditType {
    case edit
    case add
}

class ProductEditViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var product: Product? = nil
    var type: ProductEditType = .edit {
        didSet {
            switch self.type {
            case .edit:
                self.title = "Edit"
            case .add:
                self.title = "Add"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapEndEditingMethod(to: self.tableView)
        self.tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: Config.TableViewCell.productEdit, bundle: nil), forCellReuseIdentifier: Config.TableViewCell.productEdit)
    }
}

// MARK: - Table view data source
extension ProductEditViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Config.TableViewCell.productEdit, for: indexPath) as! ProductEditTableViewCell
            cell.nameTextView.delegate = self
            cell.colorTextView.delegate = self
            cell.descriptionTextView.delegate = self
            cell.didTapAvatarImageClosure = {
                self.presentImagePicker()
            }
            cell.didTapOkButtonClosure = {
                self.navigationController?.popViewController(animated: true)
                //TODO: Firebase Data
                
            }
            if let product = product {
                cell.nameTextView.text = product.name
                cell.avatarImage = product.avatar
                cell.colorTextView.text = product.color
                cell.descriptionTextView.text = product.description
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension ProductEditViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let startHeight = textView.frame.size.height
        let calcHeight = textView.sizeThatFits(textView.frame.size).height
        if (startHeight != calcHeight) {
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}

extension ProductEditViewController {
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
