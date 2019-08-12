//
//  ProductDetailTableViewCell.swift
//  ShopSide
//
//  Created by Wu on 2019/7/29.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import Firebase

class ProductDetailTableViewCell: UITableViewCell {
    
    var product: Product?
    var didTappedDeleteButtonClosure:(()->())?
    var didTappedDeliverButtonClosure:(()->())?
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBAction func deleteButtonDidTouchUpInside(_ sender: Any) {
        if let closure = self.didTappedDeleteButtonClosure {
            closure()
        }
    }
    @IBAction func deliverButtonDidTouchUpInside(_ sender: Any) {
        if let closure = self.didTappedDeliverButtonClosure {
            closure()
        }
    }
    func configCell(with product: Product) {
        self.product = product
        self.nameLabel.text = product.name
        self.displayImageView.image = product.avatar
        product.productDidChangedImage = { (image) in
            self.displayImageView.image = image
        }
        self.colorLabel.text = product.color
        self.descriptionLabel.text = product.description
        self.priceLabel.text = product.price
    }
}
