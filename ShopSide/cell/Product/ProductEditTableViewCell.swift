//
//  ProductEditTableViewCell.swift
//  ShopSide
//
//  Created by Wu on 2019/7/30.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import GMStepper
import LGButton

class ProductEditTableViewCell: UITableViewCell {

    var product: Product? = nil {
        didSet {
            self.avatarImage = self.product?.avatar
            self.nameTextView.text = self.product?.name
            self.stepper.value = Double(self.product?.availableCount ?? 0)
            self.colorTextView.text = self.product?.color
            self.descriptionTextView.text = self.product?.description
            self.priceTextView.text = self.product?.price
        }
    }
    
    var didTapAvatarImageClosure: (()->())?
    var didTapOkButtonClosure: (()->())?
    var didUpdateProductClosure: ((Product?)->())?
    var textViewDidChangedClosure: ((UITextView)->())?
    var activityChangedContent: ActivityChangedContent?
    
    @IBOutlet fileprivate weak var avatarImageView: ShadowImageView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var colorTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceTextView: UITextView!
    @IBOutlet weak var okButton: LGButton!
    
    var avatarImage: UIImage? {
        didSet {
            if self.avatarImage == nil {
                self.avatarImageView.image = UIImage(named: "ic_addcloud")
                self.avatarImageView.contentMode = .center
            } else {
                self.avatarImageView.image = avatarImage
                self.avatarImageView.contentMode = .scaleAspectFill
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(didTappedAvatarImage))
        self.avatarImageView.addGestureRecognizer(tapGes)
        
        
        self.stepper.addTarget(self, action: #selector(ProductEditTableViewCell.stepperValueChanged), for: .valueChanged)
    }
    
    @objc func didTappedAvatarImage() {
        if let closure = self.didTapAvatarImageClosure {
            closure()
        }
    }
    
    @IBAction func okButtonDidTouchUpInside() {
        if let closure = self.didTapOkButtonClosure {
            closure()
        }
    }
}

//MARK: Stepper
extension ProductEditTableViewCell {
    
    @objc func stepperValueChanged(stepper: GMStepper) {
        self.product?.availableCount = Int(stepper.value)
        self.activityChangedContent?.isCount = true
        if let closure = self.didUpdateProductClosure {
            closure(self.product)
        }
    }
}

//MARK: UITextViewDelegate
extension ProductEditTableViewCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == self.nameTextView) {
            self.product?.name = textView.text
            self.activityChangedContent?.isName = true
        } else if (textView == self.colorTextView) {
            self.product?.color = textView.text
            self.activityChangedContent?.isColor = true
        } else if (textView == self.descriptionTextView) {
            self.product?.description = textView.text
            self.activityChangedContent?.isDescription = true
        } else if (textView == self.priceTextView) {
            self.product?.price = textView.text
            self.activityChangedContent?.isPrice = true
        }
        
        if let closure = self.didUpdateProductClosure {
            closure(self.product)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let closure = self.textViewDidChangedClosure {
            closure(textView)
        }
    }
    
}
