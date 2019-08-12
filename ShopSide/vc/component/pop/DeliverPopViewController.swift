//
//  DeliverPopViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/8/10.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import GMStepper

class DeliverPopViewController: BaseViewController {

    var productImage: UIImage?
    var deliver: Deliver = Deliver(productID: "", count: 0, address: "")
    @IBOutlet weak var stepper: GMStepper!
    
    @IBOutlet weak var deliverAddressTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productImageView.image = self.productImage
        
        self.stepper.addTarget(self, action: #selector(ProductEditTableViewCell.stepperValueChanged), for: .valueChanged)
        
        self.deliverAddressTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            self.deliver.address = text
            if text == "" {
                self.deliverAddressTextfield.errorMessage = "EMPTY ADDRESS"
            } else {
                self.deliverAddressTextfield.errorMessage = ""
            }
        }
    }
}

//MARK: Stepper
extension DeliverPopViewController {
    
    @objc func stepperValueChanged(stepper: GMStepper) {
        self.view.endEditing(true)
        self.deliver.orderCount = Int(stepper.value)
    }
}

