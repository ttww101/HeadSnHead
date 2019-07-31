//
//  ProductEditTableViewCell.swift
//  ShopSide
//
//  Created by Wu on 2019/7/30.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit

class ProductEditTableViewCell: UITableViewCell {

    var didTapAvatarImageClosure: (()->())?
    var didTapOkButtonClosure: (()->())?
    
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var avatarImageView: ShadowImageView! {
        didSet {
            if self.avatarImageView?.image == nil {
                self.avatarImageView.image = UIImage(named: "ic_addcloud")
                self.avatarImageView.contentMode = .center
            } else {
                self.avatarImageView.contentMode = .scaleAspectFill
            }
        }
    }
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
    @IBOutlet weak var colorTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(didTappedAvatarImage))
        self.avatarImageView.addGestureRecognizer(tapGes)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
