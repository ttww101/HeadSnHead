//
//  ProductDetailViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/7/29.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import Firebase
import PopupDialog

class ProductDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var product: Product? = nil {
        didSet {
            if self.tableView != nil {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
        }
        self.title = "Info"
        tableView.register(UINib(nibName: Config.TableViewCell.Product.detail, bundle: nil), forCellReuseIdentifier: Config.TableViewCell.Product.detail)
        tableView.tableFooterView = UIView()
        
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "ic_editinfo"), for: .normal)
        btn1.imageView?.contentMode = .scaleAspectFit
        btn1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
        btn1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn1.addTarget(self, action: #selector(editButtonDidTouchUpInside), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        self.navigationItem.rightBarButtonItem  = item1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func editButtonDidTouchUpInside() {
        guard let vc = self.createViewControllerFromStoryboard(name: Config.Storyboard.product, identifier: Config.Controller.Product.edit) as? ProductEditViewController else { return }
        vc.type = .edit
        vc.product = self.product
        vc.didUpdateClosure = { (product) in
            self.product = product
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    // MARK: - Table view data source
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let product = product else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: Config.TableViewCell.Product.detail, for: indexPath) as! ProductDetailTableViewCell
        cell.configCell(with: product)
        cell.didTappedDeliverButtonClosure = {
            self.deliverProduct(product)
        }
        cell.didTappedDeleteButtonClosure = {
            self.deleteProduct(product)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
}

//Private method
extension ProductDetailViewController {
    
    func deliverProduct(_ product: Product) {

        guard let deliverPopVc = self.createViewControllerFromStoryboard(name: Config.Storyboard.popup, identifier: Config.Controller.Popup.deliver) as? DeliverPopViewController else { return }
        
        deliverPopVc.productImage = product.avatar
        deliverPopVc.deliver.productID = product.id
        
        // Create the dialog
        let popup = PopupDialog(viewController: deliverPopVc,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        let buttonOne = DefaultButton(title: "Admit") {
            
            deliverPopVc.view.endEditing(true)
            
            if (self.checkIfInfoFilled(deliverPopVc) == false) {
                return
            }
            
            popup.dismiss()
            
            let ref = Database.database().reference().child(Config.Firebase.Delivers.nodeName)

            FirebaseManager.shared.updateData(value: deliverPopVc.deliver.createValue(), ref: ref, childID: UUID().uuidString) { err in

                if err != nil {
                    self.showErrorAlert(error: err, myErrorMsg: nil)
                    return
                } else {
                    let title = "\(product.name)*\(deliverPopVc.deliver.orderCount)"
                    let message = "Has been ordered."
                    let image = product.avatar
                    let popup = PopupDialog(title: title, message: message, image: image)
                    let buttonOne = DefaultButton(title: "OK") {
                    }
                    buttonOne.titleColor = .darkGray
                    popup.addButtons([buttonOne])
                    self.present(popup, animated: true, completion: nil)
                }
            }
        }
        
        let buttonTwo = CancelButton(title: "Cancel") {
        }
        
        buttonOne.dismissOnTap = false
        buttonOne.titleColor = .darkGrass()
        buttonOne.titleFont = UIFont(name: "Menlo-Bold", size: 16)
        buttonTwo.titleColor = .lightRoss()
        buttonTwo.titleFont = UIFont(name: "Menlo-Bold", size: 16)
        popup.addButtons([buttonTwo, buttonOne])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    func deleteProduct(_ product: Product) {
        
        let title = product.name
        let message = "Delete product?"
        let image = product.avatar
        let popup = PopupDialog(title: title, message: message, image: image)
        let buttonOne = DefaultButton(title: "Delete") {
            
            let ref = Database.database().reference().child(Config.Firebase.Product.nodeName).child(product.id)
            
            FirebaseManager.shared.deleteData(ref: ref) {
                 self.navigationController?.popViewController(animated: true)
                
                let activityType: ActivityType = .delete
                let content = "name: \(product.name)\ncount: \(product.availableCount)\ncolor: \(product.color)\nprice: \(product.price)\ndescription: \(product.description)"
                let title = "\(activityType)"
                let owner = CurrentUser.user.name
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                formatter.locale = Locale.current
                let currentTime = formatter.string(from: Date())
                
                let activity = Activity(type: activityType, owner: owner, ownerPhotoURL:  CurrentUser.user.photoURL,  activityID: UUID().uuidString, title: title, content: content, productID: self.product?.id ?? "no product id", productPhotoURL: self.product?.photoURL ?? "", time: currentTime)
                
                FirebaseManager.shared
                    .createActivityData(value: activity.switchToFirebaseJsonValue(), completion: nil)
            }
            
        }
        
        let buttonTwo = CancelButton(title: "Cancel") {
        }
        
        buttonOne.titleColor = .lightRoss()
        buttonOne.titleFont = UIFont(name: "Menlo-Bold", size: 16)
        buttonTwo.titleColor = .darkGray
        buttonTwo.titleFont = UIFont(name: "Menlo-Bold", size: 16)
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
}

//MARK: Private
extension ProductDetailViewController {
    func checkIfInfoFilled(_ vc: DeliverPopViewController) -> Bool {
        if (vc.deliverAddressTextfield.text == "") {
            vc.deliverAddressTextfield.errorMessage = "EMPTY ADDRESS"
            return false
        }
        if (vc.deliver.orderCount == 0) {
            vc.showErrorAlert(error: nil, myErrorMsg: "Deliver count can't be 0.")
            return false
        }
        return true
    }
}
