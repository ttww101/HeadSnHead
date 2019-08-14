//
//  ActivityHomeTableViewself.swift
//  ShopSide
//
//  Created by Wu on 2019/8/5.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit
import SwipeCellKit

class ActivityHomeTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleSeperatorView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var productImageView: ShadowImageView!
    var productImage: UIImage? {
        didSet {
            if self.productImage == nil {
                self.productImageView.image = UIImage(named: "ic_addcloud")
                self.productImageView.contentMode = .center
            } else {
                self.productImageView.image = self.productImage
                self.productImageView.contentMode = .scaleAspectFill
            }
        }
    }
    @IBOutlet fileprivate weak var ownerImageView: ShadowImageView!
    var ownerImage: UIImage? {
        didSet {
            if self.ownerImage == nil {
                self.ownerImageView.image = UIImage(named: "ic_profile")
                self.ownerImageView.contentMode = .center
            } else {
                self.ownerImageView.image = self.ownerImage
                self.ownerImageView.contentMode = .scaleAspectFill
            }
        }
    }
    
    func configCell(with activity: Activity) {
        self.titleLabel.text = activity.title
        self.contentLabel.text = activity.content
        self.ownerNameLabel.text = activity.owner
        self.timeLabel.text = activity.time
        self.productImage = activity.productImage
        activity.didDownloadFinishedProductImage = { image in
            self.productImage = image
        }
        self.ownerImage = activity.ownerImage
        activity.didDownloadFinishedOwnerImage = { image in
            self.ownerImage = image
        }
        
        var color: UIColor = .darkGray
        switch activity.type {
        case ActivityType.update:
            color = .darkBlueGray()
        case ActivityType.create:
            color = .darkGrass()
        case ActivityType.delete:
            color = .lightRoss()
        }
        self.titleLabel.textColor = color
        self.titleSeperatorView.backgroundColor = color
        
    }
}
