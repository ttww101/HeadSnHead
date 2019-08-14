//
//  DeliverHomeTableViewCell.swift
//  ShopSide
//
//  Created by Wu on 2019/8/12.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import SnapKit
import LGButton

class DeliverHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var stateButton: LGButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentView.snp.makeConstraints { (make) in
//            make.top.equalTo(self).inset(10)
//            make.leading.equalTo(self).inset(10)
//            make.trailing.equalTo(self).inset(10)
//            make.bottom.equalTo(self).inset(0)
//        }
        self.borderView.layer.masksToBounds = true
        self.borderView.layer.cornerRadius = 10
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func configCell(with deliver: Deliver) {
        self.idLabel.text = deliver.productID
        self.countLabel.text = "\(deliver.orderCount)"
        self.addressLabel.text = deliver.address
        self.timeLabel.text = deliver.createTime
        switch deliver.state {
        case .ordered:
            self.stateButton.borderColor = UIColor.orange
            self.stateButton.titleColor = .orange
        case .delivering:
            self.stateButton.borderColor = .gold()
            self.stateButton.titleColor = .darkGold()
        case .delivered:
            self.stateButton.borderColor = .grass()
            self.stateButton.titleColor = .darkGrass()
        }
        self.stateButton.titleString = deliver.state.rawValue
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
