//
//  ProductEditViewController.swift
//  ShopSide
//
//  Created by Wu on 2019/7/29.
//  Copyright © 2019 FCCutomer. All rights reserved.
//

import UIKit

enum ProductEditType {
    case edit
    case add
}

class ProductEditViewController: UIViewController {

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
