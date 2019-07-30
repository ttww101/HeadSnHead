//
//  ProductDetailTableViewCell.swift
//  ShopSide
//
//  Created by Wu on 2019/7/29.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit

class ProductDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
