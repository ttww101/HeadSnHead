//
//  ProductEditTableViewCell.swift
//  ShopSide
//
//  Created by Wu on 2019/7/30.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit

class ProductEditTableViewCell: UITableViewCell {

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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
